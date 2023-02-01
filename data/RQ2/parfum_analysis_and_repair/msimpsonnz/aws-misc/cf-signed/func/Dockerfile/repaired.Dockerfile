FROM amazonlinux:1

WORKDIR /tmp
#install the dependencies
RUN yum -y install gcc-c++ && yum -y install findutils && rm -rf /var/cache/yum

RUN touch ~/.bashrc && chmod +x ~/.bashrc

RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

RUN source ~/.bashrc && nvm install 10

WORKDIR /build