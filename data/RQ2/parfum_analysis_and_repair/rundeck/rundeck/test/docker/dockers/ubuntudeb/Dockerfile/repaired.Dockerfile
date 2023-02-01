FROM ubuntu:16.04

## General package configuration
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
        sudo \
        debconf-utils \
        apt-utils \
        apt-transport-https \
        wget && rm -rf /var/lib/apt/lists/*;

RUN echo "deb https://dl.bintray.com/rundeck/rundeck-deb /" | sudo tee -a /etc/apt/sources.list

RUN wget -qO - https://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add -

RUN sudo apt-get -y update

## install openjdk 8
RUN sudo apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

## DEBUG ENV VARS AT THIS POINT
#RUN echo "**** ENV VARS START ****" && printenv > /env_at_build_time && cat /env_at_build_time && echo "**** ENV VARS END ****"

# RUNDECK

## RUNDECK setup env

ENV USERNAME=rundeck \
    USER=rundeck \
    HOME=/home/rundeck \
    LOGNAME=$USERNAME \
    TERM=xterm-256color
#
# RUNDECK - create user
RUN adduser --shell /bin/bash --home $HOME --gecos "" --disabled-password $USERNAME && \
    passwd -d $USERNAME && \
    addgroup $USERNAME sudo

COPY run.sh $HOME/run.sh
RUN sudo chmod +x $HOME/run.sh

RUN chown -R $USERNAME:$USERNAME $HOME
WORKDIR $HOME
USER rundeck

#download debian package
RUN sudo apt-get install --no-install-recommends -y rundeck && rm -rf /var/lib/apt/lists/*;

# RUNDECK - install

EXPOSE 22 4440 4443

# Start the instance.
CMD $HOME/run.sh

