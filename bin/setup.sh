#!/bin/bash
# Setup Jboss Data Virtualization environment from scratch
# @author Rodrigo Ramalho - rramalho@redhat.com
#                           github.com/hodrigohamalho

function _applyPatch(){
  echo "Applying patch..."
  PATCH_NAME=$1
  SECONDS_TO_WAIT=$2

  sh jboss-eap-6.4/bin/standalone.sh &
  sleep 1
  JBOSS_PID=$(pgrep -f Standalone)
  echo "JBOSS PID $JBOSS_PID"
  sleep $SECONDS_TO_WAIT
  sh jboss-eap-6.4/bin/jboss-cli.sh -c "patch apply patches/$PATCH_NAME"
  kill $JBOSS_PID
}

function install(){
  echo "installing..."
  unzip jboss-eap-6.4.0.zip &&
  # is there another jboss running ?
  _applyPatch "jboss-eap-6.4.3-patch.zip" 5

  echo "Jboss Data Virtualization"
  java -jar jboss-dv-installer-6.2.0.redhat-3.jar config/jdv-config.xml &&
  echo "Applying patch"
  _applyPatch "BZ-1289142.zip" 20
}

function uninstall(){
  echo "uninstalling...."
  rm -rf jboss-eap-6.4
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
