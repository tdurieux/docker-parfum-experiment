FROM ubuntu:17.04

RUN apt-get clean && apt-get update
RUN apt-get install -y --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;

RUN /usr/sbin/locale-gen en_US.UTF-8
RUN /usr/sbin/update-locale LANG=en_US.UTF-8

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y git curl zip unzip parallel \
                    postgresql-9.6 postgresql-9.6-postgis-2.3 && rm -rf /var/lib/apt/lists/*;

COPY geonb.sh /usr/local/bin/run-cache
