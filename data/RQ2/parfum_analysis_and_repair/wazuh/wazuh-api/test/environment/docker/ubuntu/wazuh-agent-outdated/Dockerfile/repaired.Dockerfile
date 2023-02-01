FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends git curl apt-transport-https lsb-release gnupg2 -y && \
    curl -f -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add - && \
    echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list && \
    apt-get update && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends wazuh-agent=3.5.0-1 -y && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /scripts/entrypoint.sh
