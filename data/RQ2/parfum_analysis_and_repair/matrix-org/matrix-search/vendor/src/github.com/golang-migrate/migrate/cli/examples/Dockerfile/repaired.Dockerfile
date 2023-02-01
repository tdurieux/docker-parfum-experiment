FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl apt-transport-https && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://packagecloud.io/golang-migrate/migrate/gpgkey | apt-key add - && \
    echo "deb https://packagecloud.io/golang-migrate/migrate/ubuntu/ xenial main" > /etc/apt/sources.list.d/migrate.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y migrate && rm -rf /var/lib/apt/lists/*;

RUN migrate -version

