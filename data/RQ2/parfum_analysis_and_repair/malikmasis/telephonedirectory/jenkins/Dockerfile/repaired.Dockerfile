FROM jenkins/jenkins

USER root

RUN apt-get update -qq && apt-get install --no-install-recommends -qqy apt-transport-https ca-certificates curl gnupg2 software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN curl -fsSL download.docker.com/linux/debian/gpg | apt-key add -

RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

RUN apt-get update -qq && apt-get install --no-install-recommends -qqy docker-ce docker-ce-cli containerd.io && rm -rf /var/lib/apt/lists/*;

RUN usermod -aG docker jenkins

ENTRYPOINT ["/bin/sh", "-c", "service docker start && /sbin/tini -- /usr/local/bin/jenkins.sh"]