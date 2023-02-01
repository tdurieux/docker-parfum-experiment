FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /app/

RUN apt-get update && apt-get -y upgrade && \
    apt-get install --no-install-recommends -y python python-yaml git python-requests python-psycopg2 \
        python-boto python-numpy && \
    git clone https://github.com/ggdhines/PanoptesScripts.git && \
    mv PanoptesScripts/panoptesPythonAPI.py ./ && \
    rm -rf PanoptesScripts && rm -rf /var/lib/apt/lists/*;

ADD crontab /etc/cron.d/aggregation

ADD . /app/

ENTRYPOINT [ "/usr/sbin/cron", "-f", "-L 15" ]
