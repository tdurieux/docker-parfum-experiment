FROM ubuntu:14.04
MAINTAINER unknonwn
LABEL Description="CSAW 2016 Regexpire" VERSION='1.0'

#installation
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y build-essential socat python && rm -rf /var/lib/apt/lists/*;

#user
WORKDIR /opt
COPY ./regexpire.py /opt/regexpire.py
RUN chmod +x /opt/regexpire.py

CMD socat -T60 TCP-LISTEN:8000,reuseaddr,fork EXEC:"python ./regexpire.py"
