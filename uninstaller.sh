#!/bin/bash

PLUGIN_NAME=plugin_easyalign

_err() {
  echo -e "\e[91m[error]:\e[0m $*" >&2
  exit 1
}

if [[ $EUID -ne 0 ]]; then
   _err "Please run this script as root."
fi

if [ $SUDO_USER ]; then
    REAL_USER=$SUDO_USER
else
    REAL_USER=$(whoami)
fi

## Get the preferences directory defined in Praat
echo "printline 'preferencesDirectory$'" > /tmp/pref_folder.praat
pref_folder=$(sudo -u $REAL_USER praat --run /tmp/pref_folder.praat)

rm -rf $pref_folder/$PLUGIN_NAME
rm -f /usr/local/bin/easyalign

echo -e "\n  Done.\n"
