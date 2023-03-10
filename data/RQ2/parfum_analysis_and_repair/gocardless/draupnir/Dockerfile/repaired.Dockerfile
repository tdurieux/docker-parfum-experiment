FROM ubuntu:18.04

ENV POSTGRESQL_VERSION=11
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        software-properties-common \
        build-essential \
        curl \
        sudo \
        btrfs-tools \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main\ndeb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg 11" > /etc/apt/sources.list.d/pgdg.list \
      && curl -f --silent -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive TZ=Europe/London apt-get --no-install-recommends install -y tzdata \
    && apt-get install --no-install-recommends -y \
        postgresql-"${POSTGRESQL_VERSION}" \
        postgresql-common \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

ENV DUMB_INIT_VERSION=1.2.1 \
    DUMB_INIT_SHA256=057ecd4ac1d3c3be31f82fc0848bf77b1326a975b4f8423fe31607205a0fe945
RUN set -x \
    && curl -f -L -o /usr/local/bin/dumb-init "https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64" \
    && echo "${DUMB_INIT_SHA256}" /usr/local/bin/dumb-init | sha256sum -c \
    && chmod +x /usr/local/bin/dumb-init

EXPOSE 5432 8443
ENTRYPOINT ["/usr/local/bin/dumb-init"]
