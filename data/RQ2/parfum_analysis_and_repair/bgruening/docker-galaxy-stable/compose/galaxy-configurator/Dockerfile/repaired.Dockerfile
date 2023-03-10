FROM alpine:3.11

RUN apk add --no-cache bash python3 \
    && pip3 install --no-cache-dir j2cli[yaml] jinja2-ansible-filters

COPY ./templates /templates
COPY ./customize.py /customize.py
COPY ./run.sh /usr/bin/run.sh

ENTRYPOINT "/usr/bin/run.sh"
