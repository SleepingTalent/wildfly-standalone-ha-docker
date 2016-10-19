FROM jboss/wildfly:latest

ENV WILDFLY_MANAGEMENT_USER admin
ENV WILDFLY_MANAGEMENT_PASSWORD admin
ENV MODCLUSTER_HOST modcluster
ENV MODCLUSTER_PORT 80
ENV ARTIFACT_NAME cluster-demo.war

ADD ${ARTIFACT_NAME} /opt/jboss/wildfly/standalone/deployments/

# Add the docker entrypoint script
ADD entrypoint.sh /opt/jboss/wildfly/bin/entrypoint.sh
ADD commands.cli /opt/jboss/wildfly/bin/commands.cli

# Change the ownership of added files/dirs to `jboss`
USER root

RUN yum -y install /sbin/ip
RUN yum -y install net-tools

# Fix for Error: Could not rename /opt/jboss/wildfly/standalone/configuration/standalone_xml_history/current
RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

RUN chown -R jboss:jboss /opt/jboss/wildfly
RUN chmod +x /opt/jboss/wildfly/bin/entrypoint.sh
RUN chmod +x /opt/jboss/wildfly/bin/commands.cli
USER jboss

EXPOSE 8080 9990 8009 45700 7600 57600

EXPOSE 23364/udp 55200/udp 54200/udp 45688/udp

ENTRYPOINT ["/opt/jboss/wildfly/bin/entrypoint.sh"]
