FROM confluentinc/ksql-cli:5.0.0-beta1
LABEL maintainer="bryan.yang@vpon.com"

RUN apt update && apt install --no-install-recommends -y supervisor && \
    mkdir /var/log/ksql && rm -rf /var/lib/apt/lists/*;

COPY ./conf/ksql-server.conf /etc/supervisor/conf.d
COPY ./conf/ksqlserver.properties /etc/ksql/
COPY ./startup.sh .

ENTRYPOINT ["./startup.sh"]
