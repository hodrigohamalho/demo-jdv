#!/bin/bash
# @author Rodrigo Ramalho - rramalho@redhat.com
#                           github.com/hodrigohamalho
# This file contain all variables used on setup.sh

JDV_BIN=/opt/binaries/jdv/jboss-dv-installer-6.2.0.redhat-3.jar
JDV_BIN_NAME=$(basename $JDV_BIN)
JDV_CONFIG=config/jdv-config.xml
JDV_PATCH=/opt/binaries/jdv/BZ-1289142.zip
JDV_START_WAIT=20

EAP_BIN=/opt/binaries/eap/jboss-eap-6.4.0.zip
EAP_PATCH=/opt/binaries/eap/jboss-eap-6.4.3-patch.zip
EAP_BIN_NAME=$(basename $EAP_BIN)
EAP_DIR=jboss-eap-6.4
EAP_START_WAIT=5
