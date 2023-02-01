FROM rdubuntu16.04-util:latest

## General package configuration
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
        sudo \
        software-properties-common \
        debconf-utils \
        uuid-runtime \
        openssh-client \
        apt-transport-https && rm -rf /var/lib/apt/lists/*;



## Install Oracle JVM
RUN apt-get update && \
  apt-get install --no-install-recommends -y openjdk-8-jdk-headless && rm -rf /var/lib/apt/lists/*;

## DEBUG ENV VARS AT THIS POINT
#RUN echo "**** ENV VARS START ****" && printenv > /env_at_build_time && cat /env_at_build_time && echo "**** ENV VARS END ****"

# RUNDECK

## RUNDECK setup env

ENV USERNAME=rundeck \
    USER=rundeck \
    HOME=/home/rundeck \
    LOGNAME=$USERNAME \
    TERM=xterm-256color

# RUNDECK - create user
RUN adduser --shell /bin/bash --home $HOME --gecos "" --disabled-password $USERNAME && \
    passwd -d $USERNAME && \
    addgroup $USERNAME sudo
ADD entry.sh /entry.sh
RUN chmod +x /entry.sh
VOLUME $HOME/rundeck
WORKDIR $HOME/rundeck

EXPOSE 4440
ENTRYPOINT ["/entry.sh"]
