FROM ubuntu:14.04

MAINTAINER Tomas Korcak "korczis@gmail.com"

ENV REFRESHED_AT 2015-01-19

RUN apt-get update && apt-get install --no-install-recommends -y nodejs nodejs-legacy git npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y



COPY . /src

RUN cd /src
RUN /usr/bin/npm install -g forever gulp bower

EXPOSE 80 3000 8080

ENTRYPOINT ["/bin/bash", "/src/start.sh"]
