FROM dockercask/base
MAINTAINER Zachary Huff <zach.huff.386@gmail.com>

RUN pacman -S --noconfirm npm python2
RUN npm install -g grunt-cli && npm cache clean --force;
RUN npm install -g jspm && npm cache clean --force;
RUN npm install -g typescript && npm cache clean --force;
RUN npm install -g tslint && npm cache clean --force;

WORKDIR /mount
