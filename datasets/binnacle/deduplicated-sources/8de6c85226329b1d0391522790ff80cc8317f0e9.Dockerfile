FROM ubuntu:16.04
RUN apt-get update && \
	apt-get -y install sudo

RUN dpkg --add-architecture i386
RUN apt-get -y update
RUN apt-get -y install libc6:i386 libstdc++6:i386
RUN apt-get -y install xinetd
RUN apt-get -y install python
RUN apt-get -y install build-essential libssl-dev libffi-dev python-dev
RUN apt-get -y install vim
RUN apt-get -y install gcc
RUN apt-get -y install gdb
RUN apt-get -y install g++-multilib
RUN apt-get -y install liburi-encode-perl
RUN apt-get -y install python2.7 python2.7-dev python-pip
RUN pip install --upgrade pip
RUN apt-get -y upgrade && apt-get -y install libssl-dev
RUN apt-get -y install python-capstone
RUN pip install --upgrade pwntools
RUN apt-get -y install strace
RUN apt-get -y install man
RUN apt-get -y install less
RUN apt-get -y install git
RUN apt-get -y install cmake
RUN pip install --upgrade filebytes
RUN pip install --upgrade keystone-engine
RUN pip install --upgrade ropper
RUN apt-get -y upgrade

# Add i386 support

RUN mkdir /challenge && chmod 775 /challenge
COPY contents/ /challenge
WORKDIR /challenge

RUN chmod 755 challenge

RUN chmod 644 flag

EXPOSE 31337
CMD ["/usr/sbin/xinetd", "-d", "-dontfork", "-f", "challenge.conf"]
