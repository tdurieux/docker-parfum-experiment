FROM debian:10

RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates telnet procps curl && rm -rf /var/lib/apt/lists/*;

ENV APP_HOME /srv
WORKDIR $APP_HOME

COPY zpan $APP_HOME

CMD ["./zpan", "server"]