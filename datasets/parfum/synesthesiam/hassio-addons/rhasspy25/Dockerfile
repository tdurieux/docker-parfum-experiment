FROM rhasspy/rhasspy:2.5.11
LABEL maintainer="Michael Hansen <hansen.mike@gmail.com>"

ENV LANG C.UTF-8

ENV CONFIG_PATH /data/options.json

COPY run.sh /

ENTRYPOINT ["/run.sh"]
