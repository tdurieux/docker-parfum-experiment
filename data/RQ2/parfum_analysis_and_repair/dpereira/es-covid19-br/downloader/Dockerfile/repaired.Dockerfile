FROM ubuntu

RUN apt-get update -y && apt-get install --no-install-recommends -y wget curl && rm -rf /var/lib/apt/lists/*;

ADD ./bin /usr/bin
