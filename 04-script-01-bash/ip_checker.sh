#!/usr/bin/env bash

# Print help
function print_help() {
    echo Usage
    echo -e "\t$0 \"<IP's>\" <PORT> [options]"
    echo KEYS
    echo -e "\tIP's\tIP's addresses for check in quotas. space - delimiter"
    echo -e "\tPORT\tport for check"
    echo OPTIONS
    echo -e "\t-c\tcount of check's for each IP. Defaults: 5"
    echo -e "\t-h\tprint help and exit"
}

# Print error description and exit with error 1
function abort() {
    echo "Invalid input - $1"
    print_help
    exit 1
}

# Check if IP format
function is_ip() {
  ip=$1

  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
      OIFS=$IFS
      IFS='.'
      ip=($ip)
      IFS=$OIFS
      [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
          && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
      return $?
  fi
  return 1
}

# Check if PORT range
function is_port() {
  if [[ $1 =~ ^[0-9]{1,5}$ ]]; then
    [[ $1 -le 65535 ]]
    return $?
  fi
  return 1
}

# Init vars
IPS=($1)
PORT=$2

# Check each IP
for ip in ${IPS[@]}
do
  if ! is_ip $ip ; then
    abort "Invalid IP's format"
  fi
done

# Check vars
if [[ -z ${PORT} ]] || ! is_port $PORT; then
  abort "Invalid PORT format"
fi

# Default count
count=5

# Read options flags
while getopts ch flag
do
  case "${flag}" in
    c) count=${OPTARG};;
    h) print_help && exit 0;;
    *) abort "Invalid options";;
  esac
done

# Check count
if [[ $count = ^[0-9]$ ]]; then
  abort "Invalid count"
fi

# curl host:port
# For each ip
for ip in ${IPS[@]}
do
  # count times
  ####### task 3
  # for i in $(seq $count)
  while (( 1 == 1))
  do
    # make curl for ip port
    curl -m 1 "http://${ip}:${PORT}" 1>/dev/null 2>&1
    # check result
    if (($? != 0))
		# and write to file result
		then
		  echo "[$(date)]|${ip}:${PORT}|NOT ACCESSIBLE" >> error.logs
		  exit 1
		else
		  echo "[$(date)]|${ip}:${PORT}|ACCESSIBLE" >> trace.logs
		fi
  done
done