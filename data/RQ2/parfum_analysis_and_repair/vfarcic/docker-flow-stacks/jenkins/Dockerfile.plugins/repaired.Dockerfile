FROM jenkins/jenkins:alpine

# Whether to skip setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Creates username and password specified through environment variables JENKINS_USER_SECRET and JENKINS_PASS_SECRET
COPY security.groovy /usr/share/jenkins/ref/init.groovy.d/security.groovy

# Install a list of plugins from the file 'plugins.txt' and their dependencies
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt