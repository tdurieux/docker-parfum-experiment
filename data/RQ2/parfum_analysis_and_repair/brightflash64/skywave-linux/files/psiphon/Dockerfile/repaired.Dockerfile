FROM ubuntu:14.04

MAINTAINER Tanmay Gupta <tanmay.tat11@gmail.com> Pulkit Chawla <pulkitchawl@gmail.com>

RUN apt-get update

RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/thispc/psiphon.git /root/psiphon

RUN apt-get -y --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install python-setuptools && rm -rf /var/lib/apt/lists/*;

RUN easy_install pexpect

RUN easy_install wget

RUN echo 'alias psiphon="cd ~/psiphon && python psi_client.py"' >> ~/.bashrc

RUN /bin/bash -c "source ~/.bashrc"

EXPOSE 1080
