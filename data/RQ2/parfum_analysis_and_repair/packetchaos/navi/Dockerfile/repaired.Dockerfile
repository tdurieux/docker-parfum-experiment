FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && apt-get install --no-install-recommends -y netcat && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN pip3 install --no-cache-dir requests && pip3 install --no-cache-dir click && pip3 install --no-cache-dir IPy && pip3 install --no-cache-dir pytenable && pip3 install --no-cache-dir navi-pro

ENV LANG en_US.utf8

ENV PATH "$PATH:/usr/bin/env/:/usr/src/app"

EXPOSE 8000

WORKDIR /usr/src/app
