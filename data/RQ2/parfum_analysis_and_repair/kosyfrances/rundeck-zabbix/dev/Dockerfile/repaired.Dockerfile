FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y apache2 zabbix-agent vim && rm -rf /var/lib/apt/lists/*;
EXPOSE 80 10050
ENTRYPOINT service apache2 start && service zabbix-agent start && /bin/bash
