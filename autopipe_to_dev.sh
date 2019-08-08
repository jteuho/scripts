#!/bin/bash

PID_BASE="${HOME}/.ssh_pipe_rova_to_dev"

VAREUI_PIDFILE="${PID_BASE}_vareui"
VAREUI_FORWARD="8104:localhost:8104"
VAREUI_PROXY="rova-demo-front"

kill=""
while getopts "k" OPT;
do
  case $OPT in
  k)
    kill="/bin/kill -15 "
    ;;
  esac
done

for PIPE in VAREUI;
do
  pidfile="${PIPE}_PIDFILE"
  forwarding="${PIPE}_FORWARD"
  proxy="${PIPE}_PROXY"

  if [ ! -z "${kill}" ];
  then
    pid=`cat ${!pidfile}`
    $kill $pid
  else
    pgrep -f ${!forwarding} >/dev/null
    if [ $? -ne "0" ];
    then
      echo "Starting autossh to ${PIPE}"
      AUTOSSH_PIDFILE=${!pidfile} autossh -M 0 -f \
      -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" \
      -N -L ${!forwarding} ${!proxy}
    else
      echo "Autossh to ${PIPE} already running"
    fi
  fi
done
