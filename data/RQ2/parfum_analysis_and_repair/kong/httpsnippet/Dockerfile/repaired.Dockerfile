# specify the node base image with your desired version node:<version>
FROM node:8

ADD . /src
WORKDIR /src

RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends -qq php7.0 php7.0-curl php7.0-cli && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qq --yes python3 && rm -rf /var/lib/apt/lists/*;
