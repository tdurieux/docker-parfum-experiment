FROM python:3.7-alpine as base

ARG default_server=127.0.0.1
ARG default_port=5557

RUN addgroup -S app && adduser -S -g docker docker
WORKDIR /home/docker
RUN apk add --no-cache gcc musl-dev libffi-dev openssl-dev
COPY requirements.txt /requirements.txt
RUN pip3 install -r /requirements.txt

USER docker
ARG default_logging=v
ARG default_logdir=/home/docker/logs
ENV SERVER=$default_server
ENV PORT=$default_port
ENV LOGGING=$default_logging
ENV LOGDIR=$default_logdir
RUN echo $PATH

CMD [ "sh", "-c", "xbox-rest-server --verbose --logfile $LOGDIR -$LOGGING -b $SERVER -p $PORT "]
