FROM python:3.7-alpine
MAINTAINER f1yegor

ADD docker-requirements.txt /app/requirements.txt
ADD grafcli.conf.example /etc/grafcli/grafcli.conf

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r /app/requirements.txt
RUN pip3 install --no-cache-dir grafcli

VOLUME ["/etc/grafcli/"]
VOLUME ["/db"]

ENTRYPOINT ["grafcli"]
