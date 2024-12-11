# Use OpenJDK 8 as the base image (with JRE 1.8.0_431)
FROM openjdk:8-jre-alpine

# Install Maven, curl, unzip, and bash using the apk package manager
RUN apk update && \
    apk add --no-cache \
    maven \
    curl \
    unzip \
    bash \
    && rm -rf /var/cache/apk/*

# Set the environment variables for jBPM, Maven, and Ant
ENV JBPM_HOME=/opt/jbpm \
    MAVEN_HOME=/usr/share/maven \
    ANT_HOME=/opt/ant \
    WILDFLY_VERSION="23.0.2.Final" \
    WILDFLY_SHA1="cd79cddc334cd58c7b9a8fc65439d4152c8d2fb8" \
    JBOSS_HOME="/opt/jbpm/standalone" \
    LAUNCH_JBOSS_IN_BACKGROUND=true \
    JBOSS_BIND_ADDRESS="0.0.0.0" \
    KIE_REPOSITORY="https://download.jboss.org/jbpm/release" \
    KIE_VERSION="7.61.0.Final" \
    KIE_CLASSIFIER="wildfly23" \
    KIE_CONTEXT_PATH="business-central" \
    KIE_SERVER_ID="sample-server" \
    KIE_SERVER_LOCATION="http://localhost:8080/kie-server/services/rest/server" \
    EXTRA_OPTS="-Dorg.jbpm.ht.admin.group=admin -Dorg.uberfire.nio.git.ssh.host=0.0.0.0"

# Create the necessary directory for jBPM
RUN mkdir -p /opt/jbpm

# Add a non-root user to run the services
RUN adduser -D -g '' jboss

# Copy the local Ant folder into the Docker image
COPY ./standalone/ant /opt/ant

# Copy the jBPM standalone files (replace with the actual path to your files)
COPY ./standalone /opt/jbpm/standalone

# Copy custom scripts into the WildFly bin directory
COPY ./etc/start_jbpm-wb.sh $JBOSS_HOME/bin/start_jbpm-wb.sh
COPY ./etc/update_db_config.sh $JBOSS_HOME/bin/update_db_config.sh

# Ensure the correct permissions for the copied files
RUN chown -R jboss:jboss $JBOSS_HOME

# Ensure the scripts have executable permissions
RUN chmod +x $JBOSS_HOME/bin/start_jbpm-wb.sh
RUN chmod +x $JBOSS_HOME/bin/update_db_config.sh



# Modify WildFly's standalone.xml to update kie-server location and server id
RUN sed -i '/<property name="org.kie.server.location" value="http:\/\/localhost:8080\/kie-server\/services\/rest\/server"\/>/d' /opt/jbpm/standalone/standalone/configuration/standalone.xml
RUN sed -i '/<property name="org.kie.server.id" value="sample-server"\/>/d' /opt/jbpm/standalone/standalone/configuration/standalone.xml

# Expose the necessary ports for jBPM (adjust if necessary)
EXPOSE 8080
EXPOSE 9990

# Set the working directory to the jBPM standalone folder
WORKDIR $JBOSS_HOME

# Run WildFly as a non-root user
USER jboss

# Default command to run when the container starts
CMD ["./bin/start_jbpm-wb.sh"]
