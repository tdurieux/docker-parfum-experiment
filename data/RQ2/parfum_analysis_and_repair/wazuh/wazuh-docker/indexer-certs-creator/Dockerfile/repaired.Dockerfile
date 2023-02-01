# Wazuh Docker Copyright (C) 2017, Wazuh Inc. (License GPLv2)
FROM ubuntu:focal

RUN apt-get update && apt-get install --no-install-recommends openssl curl -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /

COPY config/entrypoint.sh /

RUN chmod 700 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]