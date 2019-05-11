#! /bin/bash

#JACKETT_LAUNCHER="mono /opt/jackett/JackettConsole.exe --NoUpdates"
JACKETT_LAUNCHER="mono /opt/jackett/JackettConsole.exe"

. /etc/jackett/updateJackett.sh

. /etc/jackett/userSetup.sh

echo "STARTING JACKETT"
sudo -u ${RUN_AS} ${JACKETT_LAUNCHER}
