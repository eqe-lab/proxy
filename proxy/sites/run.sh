#!/bin/bash

[[ ! -z "$DEBUG" ]] && set -x

if [ ! -z "$APACHE_SITE_CONF_DIR" ] || [ ! -d "$APACHE_SITE_CONF_DIR" ]; then
    APACHE_SITE_CONF_DIR=/etc/apache2/sites-available
fi

MODE=$2
CONFIG=$1

if [ -z "${MODE}" ]; then
    MODE="ENABLE"
fi

if [ -z "${CONFIG}" ]; then
    CONFIG="ALL"
fi

enable(){
    _FILE=$1
    __MODE=$2
    if [ -z "${__MODE}" ]; then
        _MODE="ENABLE"
    else
        _MODE=$(echo ${__MODE} | tr [a-z] [A-Z])
    fi
    # echo "MODE is ${_MODE}"
    if [ ${_MODE} == "ENABLE" ] || [ ${_MODE} == "E" ];then
        _CMD="a2ensite ${_FILE}"
    elif [ ${_MODE} == "DISABLE" ] || [ ${_MODE} == "D" ];then
        _CMD="a2dissite ${_FILE}"
    else 
        echo "Wrong Parametes of ${__MODE}"
        exit
    fi
    eval ${_CMD}
}

ALL_CONFIG=`ls -l "${APACHE_SITE_CONF_DIR}/" | awk '/^-.*[0-9][0-9][0-9]-[A-Za-z]+\.conf$/ {print $NF}' `


CASE_CONFIG=$(echo $CONFIG | tr [a-z] [A-Z])
CASE_MODE=$(echo $MODE | tr [a-z] [A-Z])

if [ ${CASE_CONFIG} == "ALL" ] || [ ${CASE_CONFIG} == "A" ];then
    ALL_CONFIG=${ALL_CONFIG}
else
    ALL_CONFIG=${CONFIG}
fi

echo "=========START========="
i=0
for FILE in ${ALL_CONFIG[@]}
do
    i=$(expr ${i} + 1)
    # echo $i
    enable ${FILE} ${MODE}
done
echo "======================="
# RELOAD="systemctl reload apache2"
RELOAD="service apache2 reload"
echo ${RELOAD}
eval ${RELOAD}
echo "FINISH ${i} JOBS!"

echo "=======WORK DONE======="
