FROM jenkins/jenkins:2.289.2-lts-jdk11
USER root
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https \
       ca-certificates curl gnupg2 \
       software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) stable"
RUN apt-get update && apt-get install --no-install-recommends -y docker-ce-cli && rm -rf /var/lib/apt/lists/*;
USER jenkins
ENV JAVA_OPTS "-Djenkins.install.runSetupWizard=false ${JAVA_OPTS:-}"
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
