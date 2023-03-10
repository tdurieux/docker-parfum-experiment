FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends vim net-tools iproute2 strace curl -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/cloudstats_agent
WORKDIR /home/cloudstats_agent

COPY out/cloudstats-agent-1.7.7.75-linux-x86_64.tar.gz /home/cloudstats-agent.tar.gz
# COPY installer /home/installer
RUN tar zvxf /home/cloudstats-agent.tar.gz -C /home/cloudstats_agent && rm /home/cloudstats-agent.tar.gz
COPY config.yml /home/cloudstats_agent/
RUN mkdir /etc/cloudstats
RUN  echo 'dsada3erdads' > /etc/cloudstats/server.key
