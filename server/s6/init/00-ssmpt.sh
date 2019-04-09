#!/usr/bin/with-contenv bash

if [[ $SSMTP_TO ]] && [[ $SSMTP_USER ]] && [[ $SSMTP_PASS ]]; then


SSMTP_TLS=${SSMTP_TLS:-YES}
SSMTP_SERVER=${SSMTP_SERVER:-localhost}
SSMTP_PORT=${SSMTP_PORT:-587}
SSMTP_HOSTNAME=${SSMTP_HOSTNAME:-localhost}

SSMTP_CONF_FILE=/etc/ssmtp/ssmtp.conf
PHP_INI_PATH=/usr/local/etc/php/php.ini


echo "Settings SSMTP-settings:"
echo "server: ${SSMTP_SERVER}"
echo "host: ${SSMTP_HOSTNAME}"
echo "port: ${SSMTP_PORT}"
echo "to: ${SSMTP_TO}"
echo "user: ${SSMTP_USER}"
echo "password: *******"

echo "root=$SSMTP_TO" > ${SSMTP_CONF_FILE}
echo "hostname=$SSMTP_HOSTNAME" >> ${SSMTP_CONF_FILE}
echo "AuthMethod=LOGIN" >> ${SSMTP_CONF_FILE}
echo "UseSTARTTLS=$SSMTP_TLS" >> ${SSMTP_CONF_FILE}
echo "FromLineOverride=YES" >> ${SSMTP_CONF_FILE}
echo "AuthUser=$SSMTP_USER" >> ${SSMTP_CONF_FILE}
echo "AuthPass=$SSMTP_PASS" >> ${SSMTP_CONF_FILE}
echo "mailhub=$SSMTP_SERVER:$SSMTP_PORT" >> ${SSMTP_CONF_FILE}


echo "[mail function]" >> ${PHP_INI_PATH}
echo "sendmail_path = /usr/sbin/ssmtp -t" >> ${PHP_INI_PATH}
else
    echo "No SSMTP-settings found, skipping"
fi