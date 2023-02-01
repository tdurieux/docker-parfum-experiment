FROM ubuntu:focal

# Install prerequisites
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
    build-essential curl gnupg devscripts debhelper dh-make git libicu-dev && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install dh-systemd && rm -rf /var/lib/apt/lists/*;


# Add NodeSource repo
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -

# Install node
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install nodejs && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
