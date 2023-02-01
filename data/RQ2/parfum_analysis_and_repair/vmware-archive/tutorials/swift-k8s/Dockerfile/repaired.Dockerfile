FROM bitnami/swift:latest

ENV APP_NAME=PerfectTemplate

COPY app-code /app/PerfectTemplate

USER root

RUN echo 'deb http://ftp.debian.org/debian jessie-backports main' | tee -a /etc/apt/sources.list && \
    apt-get update && apt-get -y --no-install-recommends -t jessie-backports install openssl libssl-dev uuid-dev && \
    chown -R bitnami:bitnami /app && rm -rf /var/lib/apt/lists/*;

USER bitnami

EXPOSE 8181

RUN swift build -C PerfectTemplate
