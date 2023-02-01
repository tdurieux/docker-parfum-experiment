FROM ubuntu

RUN apt-get -y update
RUN apt-get -y install curl git upower

RUN useradd -ms /bin/bash derf
USER derf
WORKDIR /home/derf
ADD bashrc /home/derf/.bashrc
RUN cat .bashrc | bash
