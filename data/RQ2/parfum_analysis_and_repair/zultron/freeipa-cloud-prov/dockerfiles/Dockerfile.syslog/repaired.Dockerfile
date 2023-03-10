FROM debian:stretch

RUN apt-get update && \
    apt-get install rsyslog --no-install-recommends -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# UID matches coreos host
RUN adduser --system --no-create-home --uid 202 --group \
        --disabled-password --disabled-login syslog

CMD ["rsyslogd", "-n"]