# DOCKER-VERSION 1.5.0
FROM      ubuntu:14.04
MAINTAINER Sasha Jovicic <sasha.jo@gmail.com>

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted" >> /etc/apt/sources.list
RUN echo "deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted" >> /etc/apt/sources.list
RUN apt-get -y update

# install python-software-properties (so you can do add-apt-repository)
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y -q python-software-properties software-properties-common && rm -rf /var/lib/apt/lists/*;

# install SSH server so we can connect multiple times to the container
RUN apt-get -y --no-install-recommends install openssh-server && mkdir /var/run/sshd && rm -rf /var/lib/apt/lists/*;

# install oracle java from PPA
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -y --no-install-recommends install oracle-java8-installer && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Set oracle java as the default java
RUN update-java-alternatives -s java-8-oracle
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> ~/.bashrc

# install utilities
RUN apt-get -y --no-install-recommends install vim git sudo zip bzip2 fontconfig curl && rm -rf /var/lib/apt/lists/*;

#install build-esential
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# install node.js from PPA
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

# Install Bower & Grunt
RUN npm install -g bower grunt-cli && npm cache clean --force;

# install yeoman
RUN npm install -g yo && npm cache clean --force;

# install Angular
RUN npm install -g generator-angular && npm cache clean --force;

# configure the "flowsim" and "root" users
RUN echo 'root:flowsim' |chpasswd
RUN groupadd flowsim && useradd flowsim -s /bin/bash -m -g flowsim -G flowsim && adduser flowsim sudo
RUN echo 'flowsim:flowsim' |chpasswd

CMD cd /home && chown -R flowsim:flowsim /home/flowsim

# expose the working directory, the Back port, the Grunt server port, the SSHD port, and run SSHD
VOLUME ["/flowsim"]
EXPOSE 8080
EXPOSE 9000
EXPOSE 22
CMD    /usr/sbin/sshd -D
