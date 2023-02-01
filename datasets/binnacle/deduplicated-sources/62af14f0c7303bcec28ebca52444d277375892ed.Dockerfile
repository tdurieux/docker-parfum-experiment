FROM openshift/jenkins-2-centos7
USER root
RUN touch /opt/openshift/configuration/plugins.txt
RUN touch /opt/openshift/plugins/openshift-pipeline-plugin.lock
COPY ./jpi /opt/openshift/plugins
RUN /usr/local/bin/install-plugins.sh /opt/openshift/configuration/plugins.txt
