FROM ubuntu:16.04


RUN apt update && apt -y full-upgrade
RUN apt autoclean && apt update

RUN apt -y --no-install-recommends install netcat \
    && apt -y --no-install-recommends install curl \
    && apt -y --no-install-recommends install openjdk-8-jdk-headless \
    && apt -y --no-install-recommends install postgresql-client-9.5 \
    && apt -y autoremove \
    && apt -y autoclean && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /opt/metasfresh
RUN curl -f https://repo.metasfresh.com/repository/mvn-release-releases/de/metas/dist/metasfresh-dist-dist/5.174.2-461+release/metasfresh-dist-dist-5.174.2-461+release-dist.tar.gz \
  | tar -xzC /opt/metasfresh/
RUN mkdir -p /opt/metasfresh/heapdump

COPY sources/configs/* /opt/metasfresh/
COPY sources/configs/local_settings.properties /root/
COPY sources/start_app.sh /opt/metasfresh/
RUN chmod 700 /opt/metasfresh/start_app.sh

ENTRYPOINT ["/opt/metasfresh/start_app.sh"]

EXPOSE 61616
