FROM jenkins/jenkins:lts
MAINTAINER https://blog.csdn.net/qq_41453285
ENV REFRESHED_AT 2020-07-27

USER root
RUN apt-get -qq update && apt-get install -y --no-install-recommends -qq sudo && rm -rf /var/lib/apt/lists/*;
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN wget https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz
RUN tar -xvzf docker-latest.tgz && rm docker-latest.tgz
RUN mv docker/* /usr/bin/

USER jenkins
RUN /usr/local/bin/install-plugins.sh junit git git-client ssh-slaves greenballs chucknorris ws-cleanup
