FROM python:3.7-alpine

ADD tests/integration/entrypoint.sh /entrypoint.sh
ADD tests/integration/wait-for-it.sh /wait-for-it.sh

RUN sed -i s/6/cdn/ /etc/apk/repositories && apk add --no-cache --update --progress make bats
ADD requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r /app/requirements.txt

RUN mkdir -p /etc/grafcli
RUN ln -s /app/grafcli.conf.example /etc/grafcli/grafcli.conf
RUN ln -s /app/scripts/grafcli /usr/local/bin/grafcli

ENV PYTHONPATH=/app

WORKDIR /app
ENTRYPOINT /entrypoint.sh
