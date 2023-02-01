FROM debian:jessie

RUN echo "deb http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/backports.list
RUN echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get update
RUN apt-get -t jessie-backports --no-install-recommends install -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl build-essential python libc6-dev-i386 lib32stdc++-4.9-dev jq && rm -rf /var/lib/apt/lists/*;

RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm

RUN curl -f -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
