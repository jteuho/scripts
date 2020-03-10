#!/bin/bash

PID_BASE="${HOME}/.ssh_pipe_to_dev"

vareui_FORWARD="8104:localhost:8104"
vareui_PROXY="rova-demo-front"

xroaddev_FORWARD="8999:10.35.33.215:80"
xroaddev_PROXY="proxy.kapa.ware.fi"

xroadtest_FORWARD="8900:10.35.33.66:8900"
xroadtest_PROXY="proxy.kapa.ware.fi"

fare_FORWARD="8889:localhost:8888"
fare_PROXY="rova-demo-registry"

search_FORWARD="8011:localhost:8011"
search_PROXY="rova-demo-backend"

all=("vareui" "xroaddev" "xroadtest" "search" "fare")

kill=""
pipes=$@
while getopts "kah" OPT;
do
  case $OPT in
  k)
    kill="/bin/kill -15 "
    ARGS=( "$@" );
    pipes=( "${ARGS[@]:1}" )
    ;;
  a)
    pipes=("${all[@]}")
    ;;
  h)
    pipes=()
    ;;
  esac
done

if [ ${#pipes[@]} -eq 0 ];
then
  echo "Usage: $0 [-k] [-a] [pipe...]"
  echo "    -k    Close pipe(s)"
  echo -e "    -a    Open or close all pipes\n"
  echo "    Opens pipe(s) by default. Use -k to close. Unless -a is given,"
  echo -e "    pipe names must be listed as parameters.\n"
  echo "    Possible pipes:"
  for PIPE in ${all[@]};
  do
    echo "    - $PIPE"
  done
  exit 1
fi

for PIPE in ${pipes[@]};
do
  pidfile="${PID_BASE}_${PIPE}"
  forwarding="${PIPE}_FORWARD"
  proxy="${PIPE}_PROXY"

  if [ -z ${!forwarding} ];
  then
    echo "Unknown pipe ${PIPE}"
    exit 1
  fi

  if [ ! -z "${kill}" ];
  then
    echo "Kill $PIPE"
    if [[ -e $pidfile ]];
    then
      pid=`cat ${pidfile}`
      $kill $pid
    else
      echo "$pidfile doesn't exist"
    fi
  else
    pgrep -f ${!forwarding} >/dev/null
    if [ $? -ne "0" ];
    then
      echo "Starting autossh to ${PIPE}"
      AUTOSSH_PIDFILE=${pidfile} autossh -M 0 -f \
      -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" \
      -N -L ${!forwarding} ${!proxy}
    else
      echo "Autossh to ${PIPE} already running"
    fi
  fi
done
