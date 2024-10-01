#!/bin/bash
# delay variable
DELAY=10

# help message
usage() {
echo '
Usage: $(basename $0) HOST SCRIPT

Examples:
  netwatch.sh 1.1.1.1 /usr/local/bin/my_script
  netwatch.sh 8.8.8.8 reboot
  netwatch.sh 1.1.1.1 "echo hello world"'
}

# check command or script exist
program_exists() {
    if ! type $1 > /dev/null 2>&1; then
        usage
        echo 
        echo "$1 is not installed"
        exit 1
    fi
}

# check count of arguments
if [ "$#" -lt 2 ]; then
    usage
    echo 
    echo Need more arguments!
    exit 22
  
elif [ "$#" -ge 3 ]; then
    usage
    echo 
    echo Too much arguments!
    exit 22
fi

# host is IP-address
HOST=$(echo $1 | awk '/((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/{print $0}')
if [ -z $HOST ]; then
    echo $1 is not IP-address
    echo
    usage
    exit 1
fi
# check script exist
SCRIPT=$2
program_exists $SCRIPT

# fail check counter
fail_check=0

# good check counter
good_check=0

# status variable
STATUS=true

while true
do
    time=$(date "+%d/%m/%Y, %H:%M:%S -")
    # ping host 
    ping -c 1 -W 5 $HOST > /dev/null

    # is ping successful?
    RESULT=$?
    if [ $RESULT -ne 0 ]; then
        fail_check=$((fail_check+1))
        if [ $fail_check -eq 3 ]; then
            echo "$time Host $HOST is unavailable"
            echo "Run script $SCRIPT"
            $SCRIPT &
            fail_check=0
        fi
        STATUS=false
        good_check=0
    elif  [ $RESULT -eq 0 ]; then
        good_check=$((good_check+1))
        if ([ $good_check -eq 3 ] && [ $STATUS != true ]); then
            echo "$time Host $HOST is available"
            good_check=0
            fail_check=0
            STATUS=true
        fi
    fi

    # delay
    sleep $DELAY
done
