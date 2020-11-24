#!/bin/bash

PLUGIN_NAME=plugin_easyalign

_err() {
  echo -e "\e[91m[error]:\e[0m $*" >&2
  exit 1
}

## Check if Praat is installed
if ! [ -x "$(command -v praat)" ]; then
  _err "Praat is not installed"
  
fi

## Check if HVite is installed
if ! [ -x "$(command -v HVite)" ]; then
  _err "HVite is not installed"
fi

## Check if Wine is installed
if ! [ -x "$(command -v wine)" ]; then
  echo "Wine is not installed, some languages may not work"
fi


if [[ $EUID -ne 0 ]]; then
   _err "Please run this script as root." 1>&2
fi

if [ $SUDO_USER ]; then
    privs="sudo -u $SUDO_USER"
fi

## Get the preferences directory defined in Praat
echo "printline 'preferencesDirectory$'" > /tmp/pref_folder.praat
pref_folder=$($privs praat --run /tmp/pref_folder.praat)

rm -rf $pref_folder/$PLUGIN_NAME
$privs git clone --depth 1 https://github.com/mlndz28/praat-easy-align-linux $pref_folder/$PLUGIN_NAME
cp $pref_folder/$PLUGIN_NAME/easyalign /usr/local/bin/easyalign

echo -e "\n  Done.\n"
