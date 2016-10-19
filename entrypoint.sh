#!/bin/sh

# Create default app server users
if [[ ! -z "${WILDFLY_MANAGEMENT_USER}" ]] && [[ ! -z "${WILDFLY_MANAGEMENT_PASSWORD}" ]]
then
	echo "=> add-user-process: creating jboss users"
    ${JBOSS_HOME}/bin/add-user.sh --silent -e -u ${WILDFLY_MANAGEMENT_USER} -p ${WILDFLY_MANAGEMENT_PASSWORD}
	echo "=> add-user-process: jboss users have been created"
fi

sed -i "s/@MODCLUSTER_HOST@/${MODCLUSTER_HOST}/" ${JBOSS_HOME}/bin/commands.cli
sed -i "s/@MODCLUSTER_PORT@/${MODCLUSTER_PORT}/" ${JBOSS_HOME}/bin/commands.cli


function wait_for_server() {
  until `${JBOSS_HOME}/bin/jboss-cli.sh -c "ls /deployment" &> /dev/null`; do
    sleep 1
  done
}

echo "=> configuration-process: starting wildfly server"
${JBOSS_HOME}/bin/standalone.sh -c standalone-ha.xml > /dev/null &

echo "=> configuration-process: waiting for the server to boot"
wait_for_server

echo "=> HOSTNAME $HOSTNAME"

echo "=> configuration-process:  executing the commands"
${JBOSS_HOME}/bin/jboss-cli.sh -c --file=`dirname "$0"`/commands.cli

echo "=> configuration-process: shutting down WildFly"
${JBOSS_HOME}/bin/jboss-cli.sh -c ":shutdown"


IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

echo "=> Starting Standalone Wildfly with HOSTNAME:IPAddress : $HOSTNAME:$IPADDR"

exec ${JBOSS_HOME}/bin/standalone.sh -c standalone-ha.xml -Djboss.bind.address=$IPADDR -Djboss.bind.address.management=$IPADDR -Djboss.bind.address.private=$IPADDR -Djboss.node.name=$HOSTNAME-$IPADDR

#exec ${JBOSS_HOME}/bin/standalone.sh -b $HOSTNAME -bmanagement $HOSTNAME -c standalone-ha.xml
