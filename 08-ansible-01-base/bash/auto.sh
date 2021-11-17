#!/usr/bin/env bash

# Print help
function print_help() {
    echo Usage
    echo -e "\t$0 \"<containers>\" <playbook> <inventory> [options]"
    echo KEYS
    echo -e "\tcontainers's\tName of containers from containers.txt which will be run. space - delimiter."
    echo -e "\tansible playbook\tAnsible playbook file"
    echo -e "\tansible playbook\tInventory file"
    echo OPTIONS
    echo -e "\t-h\tPrint help and exit"
}

# Print error description and exit with error 1
function abort() {
    echo "Invalid input - $1"
    print_help
    exit 1
}

function check_exec () {
    echo -ne "   ${1}"
    if echo && eval ${2}
    then
        echo -ne "\e[32m[OK]"
        echo -ne "\e[39m"
        echo
    else
        echo -ne "\e[31m[FAIL]"
        echo -ne "\e[39m"
        echo
        exit 1
    fi
}

function clear_containers() {
    # Stop and remove images and containers
    for cntr in ${CNTRS[@]}
    do
        check_exec "Removing container ${cntr}..." "docker rm --force ${cntr}"
        # check_exec "Removing image ${cntr}..." "docker image rm ${!cntr}"
    done
}


# Source containers
source containers.txt

#Init vars
CNTRS=($1)
PLBK=$2
INVTR=$3

### Read options flags
while getopts h flag
do
  case "${flag}" in
    h) print_help && exit 0;;
    *) abort "Invalid options";;
  esac
done

# Stop and remove images and containers
clear_containers

# Run containers
for cntr in ${CNTRS[@]}
do
  check_exec "Runing container ${cntr}..." "docker run -d --name ${cntr} ${!cntr} sleep 6000000"
done

# Check ansible playbook
# check_exec "Checking playbook" "ansible-playbook -i ${INVTR} ${PLBK} --ask-vault-password --check"

# Run ansible playbook
check_exec "Play playbook" "ansible-playbook -i ${INVTR} ${PLBK} --ask-vault-password"

# Stop and remove images and containers
clear_containers
