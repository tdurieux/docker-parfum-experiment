FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install curl npm && rm -rf /var/lib/apt/lists/*;
RUN curl -f --silent --location https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get install --no-install-recommends --yes build-essential nodejs && npm install --global yarn && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

COPY . /src
RUN cd /src; yarn

EXPOSE 3000

WORKDIR /src
CMD ["/usr/bin/yarn", "start"]
