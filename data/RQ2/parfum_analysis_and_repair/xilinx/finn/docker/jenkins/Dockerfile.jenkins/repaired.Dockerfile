FROM jenkins/jenkins:lts
# if we want to install via apt
USER root
RUN apt-get update
RUN apt-get install --no-install-recommends -y gnupg-agent curl ca-certificates apt-transport-https software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install --no-install-recommends -y docker-ce-cli && rm -rf /var/lib/apt/lists/*;
# drop back to the regular jenkins user - good practice
USER jenkins
