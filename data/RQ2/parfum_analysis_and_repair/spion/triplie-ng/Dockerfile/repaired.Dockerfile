FROM moul/node
MAINTAINER Manfred Touron "m@42.am"

ADD . /triplie
RUN cd /triplie && \
    npm install -g && \
    mkdir /data && npm cache clean --force;
WORKDIR /data

CMD ["triplie", "config.yaml"]
