FROM jenkinsci/jenkins:2.66

USER root

RUN apt-get update -qq && apt-get install --no-install-recommends -qqy \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    lxc \
    iptables \
    dos2unix && rm -rf /var/lib/apt/lists/*;

RUN wget -qO- https://get.docker.com/ | sh
RUN touch /var/run/docker.sock

RUN curl -f -L https://github.com/docker/compose/releases/download/1.8.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
COPY start.sh /tmp/start.sh

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN dos2unix /usr/share/jenkins/plugins.txt
RUN dos2unix /tmp/start.sh && chmod +x /tmp/start.sh
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

COPY seed.groovy /usr/share/jenkins/ref/init.groovy.d/seed.groovy

ENTRYPOINT ["/bin/bash", "-c", "/tmp/start.sh"]
