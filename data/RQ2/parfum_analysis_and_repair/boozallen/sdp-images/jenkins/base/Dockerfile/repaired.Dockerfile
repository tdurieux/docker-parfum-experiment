# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM jenkins/jenkins:2.176.2

ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false"

EXPOSE 8080
EXPOSE 50000

USER root

# install plugins
COPY resources/plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# insert configuration script
COPY resources/scripts/configure.groovy /var/jenkins_home/init.groovy.d/configure.groovy
RUN chmod 777 /var/jenkins_home/init.groovy.d/*

# copy in entry point scripts