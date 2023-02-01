FROM ubuntu:bionic

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://packagecloud.io/golang-migrate/migrate/gpgkey | apt-key add -
RUN echo "deb https://packagecloud.io/golang-migrate/migrate/ubuntu/ bionic main" > /etc/apt/sources.list.d/migrate.list
RUN apt-get update && \
    apt-get install --no-install-recommends -y migrate && rm -rf /var/lib/apt/lists/*;

RUN migrate -version
