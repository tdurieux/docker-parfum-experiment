FROM ubuntu:14.04
LABEL maintainer=radorado@hackbulgaria.com


#Updating APT sources and installing some OS dependencies and tools to add 3rd party repos later on
RUN apt-get update && apt-get install -y git software-properties-common python-software-properties build-essential curl sudo patch gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev



#old DEADSNAKES repo is discontinued so it cannot be authenticated anymore
#ppa:fkrull/deadsnakes
#should use ppa:deadsnakes/ppa instead

#Adding 3rd party repos for python, java, nodejs stuff. apt-get update will run automatically after adding nodejs repo
RUN add-apt-repository ppa:deadsnakes/ppa
RUN sudo add-apt-repository ppa:openjdk-r/ppa
RUN apt-add-repository ppa:brightbox/ruby-ng 
RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -


#Installing python3.6
#IF later on we change to python3.7 we should change it at ../hacktester/tester/tasks/docker_utils.py
RUN sudo apt-get install -y python3.6

#Installing Java stuff
RUN sudo apt-get install -y openjdk-8-jdk

#Setting up java realm
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

RUN java -version

#Installing ruby stuff
RUN apt-get install -y ruby2.4 ruby2.4-dev && gem install rake && gem install minitest && gem install rubocop

#install nodejs and mocha,chai and sinon test tools
RUN sudo apt-get install -y nodejs && npm install -g mocha chai sinon

#Install pip and flake8
RUN curl -O https://bootstrap.pypa.io/get-pip.py && python3.6 get-pip.py && pip -V && pip install flake8

#Installing bash-completion htop and mtr just in case
RUN apt-get install bash-completion htop mtr

#Cleaning downloaded packages
RUN apt-get clean

#Creating new user
RUN useradd -m -p grader -s /bin/bash grader -G sudo
RUN echo 'grader:grader' | chpasswd
RUN usermod -u 1002 grader

USER grader
