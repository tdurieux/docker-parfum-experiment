FROM alpine:3.11.2
MAINTAINER Matt Wise <matt@nextdoor.com>

RUN apk add --no-cache --update bash python3 ca-certificates curl wget

RUN mkdir /app /app/zk_watcher

ADD requirements*.txt /app/
RUN pip3 install --no-cache-dir -r /app/requirements.test.txt -r

ADD setup.py /app/
ADD README.rst /app/
ADD zk_watcher /app/zk_watcher/
RUN cd /app; python3 setup.py install

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
