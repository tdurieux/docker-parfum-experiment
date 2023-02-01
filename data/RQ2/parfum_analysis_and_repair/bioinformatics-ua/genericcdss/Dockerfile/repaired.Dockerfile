FROM    python:2.7
MAINTAINER Joao Almeida

ADD     ./Backend /GenericCDSS/Backend
ADD     ./UI /GenericCDSS/UI
ADD     ./Makefile /GenericCDSS/Makefile
ADD     ./config /GenericCDSS/config

RUN apt-get update && \
        apt-get install --no-install-recommends -y -q jq vim curl nginx uwsgi-plugin-python && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -

RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR  /GenericCDSS

RUN cd UI/ && npm install && npm cache clean --force;

RUN     mkdir -p /var/log/gunicorn

RUN     pip install -r ./config/requirements.pip --no-cache-dir
