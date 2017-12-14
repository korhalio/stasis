#!/bin/bash

if [ -z "${USERID}" ]; then
    USERID=$(ls -ln /src | tail -n 1 | awk '{print $3}')
    echo "building as uid ${USERID}. if you dont want that add -e USERID=\$UID to docker run"
fi

LINE=$(grep -F "dockeruser" /etc/passwd)
# replace all ':' with a space and create array
array=( ${LINE//:/ } )

# home is 5th element
USER_HOME=${array[4]}

sed -i -e "s/^dockeruser:\([^:]*\):[0-9]*:[0-9]*/dockeruser:\1:${USERID}:${USERID}/"  /etc/passwd

chown -R ${USERID}:${USERID} ${USER_HOME}

su dockeruser -c "$*"
