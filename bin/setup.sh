#!/bin/bash
# Setup Jboss Data Virtualization environment from scratch
# @author Rodrigo Ramalho - rramalho@redhat.com
#                           github.com/hodrigohamalho
# This script shouldn't be updated
# all settings is on setup.env.sh file

. setup.env.sh

function _applyPatch(){
  echo "Applying patch..."
  PATCH=$1
  SECONDS_TO_WAIT=$2

  sh $EAP_DIR/bin/standalone.sh &
  sleep 1
  JBOSS_PID=$(pgrep -f Standalone)
  echo "JBOSS PID $JBOSS_PID"
  sleep $SECONDS_TO_WAIT
  sh $EAP_DIR/bin/jboss-cli.sh -c "patch apply $PATCH"
  kill $JBOSS_PID
}

function _startDockerMachine(){
  DOCKER_MACHINE_STATUS=$(docker-machine status default)
  if [ "$DOCKER_MACHINE_STATUS" != "Running" ]; then
    echo "starting docker-machine..."
    docker-machine start default 2>&1 | grep "Started machines" && eval $(docker-machine env default)
  fi
}

function install(){
  echo "installing..."

  if [ -d "$EAP_DIR" ]; then
    uninstall
  fi

  unzip $EAP_BIN -d . &&
  # is there another jboss running ?
  _applyPatch "$EAP_BIN_NAME" $EAP_START_WAIT

  echo "Jboss Data Virtualization"
  java -jar $JDV_BIN $JDV_CONFIG &&
  echo "Applying patch"
  _applyPatch "$JDV_PATCH" $JDV_START_WAIT

  if [ $(uname) == 'Darwin' ]; then
    _startDockerMachine
  else
    # TODO start docker for Linux
  fi

  docker-compose -f ../docker-compose.yml up
}

function uninstall(){
  echo "uninstalling...."
  rm -rf $EAP_DIR
}

function reset(){
  echo "reset..."
}

function usersInfo(){
  echo "EAP ADMIN: admin"
  echo "DASHBOARD: dashboardAdmin"
  echo "TEIID:     teiidUser"
  echo "modeshape: modeshapeUser"
  echo "passwd: redhat@123"
}

case "$1" in
        install)
            install
            ;;

        uninstall)
            uninstall
            ;;

        reset)
            reset
            ;;
        usersInfo)
            usersInfo
            ;;

        *)
            echo $"Usage: $0 {install|uninstall|reset|usersInfo}"
            exit 1

esac
