FROM ubuntu:16.04


VOLUME /var/lib/docker

## General package configuration
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
        sudo \
        unzip \
        curl \
        iputils-ping \
        xmlstarlet \
        ssh && rm -rf /var/lib/apt/lists/*;

## Set up env
ENV USERNAME=rundeck \
    HOME=/home/rundeck

## Create rundeck user
RUN adduser --shell /bin/bash --home $HOME --gecos "" --disabled-password $USERNAME && \
    passwd -d $USERNAME && \
    addgroup $USERNAME sudo

## Copy scripts
RUN mkdir -p $HOME/scripts
COPY scripts $HOME/scripts
RUN sudo chmod -R a+x $HOME/scripts/*

ARG RUNDECK_NODE
#RUN ssh-keygen
VOLUME $HOME/resources
RUN mkdir -p $HOME/resources
RUN $HOME/scripts/createnode.sh $RUNDECK_NODE "username=\"$USERNAME\"" 'tags="remote"' 'ssh-send-env="true"' "ssh-keypath=\"$HOME/resources/$RUNDECK_NODE.rsa\"" > $HOME/$RUNDECK_NODE.xml

RUN chown -R $USERNAME:$USERNAME $HOME

# generate resource.xml

# Set Run Context
USER $USERNAME
WORKDIR $HOME
#VOLUME $HOME/resources
RUN sudo mkdir /var/run/sshd
#CMD $HOME/run.sh
CMD $HOME/scripts/run.sh
