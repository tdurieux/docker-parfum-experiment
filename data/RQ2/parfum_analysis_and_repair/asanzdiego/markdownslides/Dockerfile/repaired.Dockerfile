FROM node:14.12.0-buster-slim
LABEL MAINTAINER Adolfo Sanz De Diego asanzdiego@gmail.com
ENV VERSION 0.0.3
# Software dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get -y --no-install-recommends install wget curl unzip chromium && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install texlive-latex-base texlive-fonts-recommended texlive-latex-extra && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install npm && rm -rf /var/lib/apt/lists/*;
# ENV PUPPETEER_SKIP_DOWNLOAD='true'
RUN npm config set unsafe-perm true
RUN npm install -g decktape@3.1.0 && npm cache clean --force;
WORKDIR /home/
RUN wget https://github.com/jgm/pandoc/releases/download/2.9.2/pandoc-2.9.2-1-amd64.deb && \
    dpkg -i pandoc-2.9.2-1-amd64.deb
RUN wget https://github.com/asanzdiego/markdownslides/archive/6.7.zip && unzip 6.7.zip
WORKDIR /home/markdownslides-master
ADD . /home/markdownslides-master
