FROM debian:latest

RUN apt-get update -qq && apt-get install --no-install-recommends iputils-ping netcat curl gnupg procps -y && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sSL https://install.zerotier.com | bash

ENTRYPOINT ["/entrypoint.sh"]
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
CMD []
