FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y curl apt-transport-https lsb-release gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | apt-key add - && \
    echo "deb https://packages.wazuh.com/3.x/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list && \
    apt-get update && apt-get install --no-install-recommends wazuh-agent=3.13.2-1 -y && rm -rf /var/lib/apt/lists/*;
