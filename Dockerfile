FROM jenkins/jenkins:2.73.1

USER jenkins

# copy existing plugins
COPY plugins/*.hpi /usr/share/jenkins/ref/plugins/

# remove executors in master
COPY config/*.groovy /usr/share/jenkins/ref/init.groovy.d/

# Copy plugins.txt
COPY plugins.txt /usr/share/jenkins/plugins.txt

# Set permissions properly
USER root
RUN chown -R jenkins:root /usr/share/jenkins

# Install plugins from plugins.txt
USER jenkins
RUN mkdir -p /usr/share/jenkins/ref/secrets/ \
    && echo "false" > /usr/share/jenkins/ref/secrets/slave-to-master-security-kill-switch \
    && /usr/local/bin/install-plugins.sh $(cat /usr/share/jenkins/plugins.txt | tr '\n' ' ')
