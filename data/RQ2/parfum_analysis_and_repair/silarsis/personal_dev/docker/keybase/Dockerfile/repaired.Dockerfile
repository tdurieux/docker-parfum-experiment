FROM ubuntu:trusty
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
RUN curl -f -sL https://deb.nodesource.com/setup | bash -
RUN apt-get -yq update && apt-get -yq upgrade
RUN apt-get -yq --no-install-recommends install gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt-get -yq --no-install-recommends install nodejs-legacy npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g keybase-installer && npm cache clean --force;
RUN keybase-installer
RUN bash
