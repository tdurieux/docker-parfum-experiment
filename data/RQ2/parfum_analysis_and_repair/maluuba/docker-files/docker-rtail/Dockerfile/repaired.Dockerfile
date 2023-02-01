FROM node:0.12.6
MAINTAINER Maluuba Infrastructure Team <infrastructure@maluuba.com>

RUN apt-get -qq update && apt-get -qq --no-install-recommends -y install inotify-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq upgrade



RUN npm install -g rtail && npm cache clean --force;

ENV FILES_IREGEX='.*\\.log' WATCH_IREGEX='.*\\.log'

ADD rtail-logs.sh /opt/rtail-logs.sh
RUN chmod +x /opt/rtail-logs.sh

WORKDIR /logs

ENTRYPOINT ["/opt/rtail-logs.sh"]
