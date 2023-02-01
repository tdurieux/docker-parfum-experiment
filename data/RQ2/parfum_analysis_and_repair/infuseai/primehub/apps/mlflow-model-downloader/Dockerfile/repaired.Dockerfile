FROM python:3.7.2-slim

WORKDIR /apps

RUN pip install --no-cache-dir --upgrade pip

ADD requirements.txt /apps
RUN pip install --no-cache-dir -r requirements.txt

ADD docker-entrypoint.sh /usr/bin
ADD *.py /apps
RUN chmod a+x /usr/bin/docker-entrypoint.sh

ENTRYPOINT [ "docker-entrypoint.sh" ]

