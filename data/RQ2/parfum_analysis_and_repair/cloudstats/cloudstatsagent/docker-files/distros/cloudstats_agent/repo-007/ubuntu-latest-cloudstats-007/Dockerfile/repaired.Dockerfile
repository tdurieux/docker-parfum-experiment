FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends tar gzip sysstat net-tools procps -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir /home/cloudstats_agent
WORKDIR /home/cloudstats_agent
RUN curl -L -O --fail 'https://cloudstatsstorage.blob.core.windows.net/agent007/cloudstats-agent-latest-linux-x86_64.tar.gz'

RUN tar zxvf cloudstats-agent-latest-linux-x86_64.tar.gz --strip-components 1 >/dev/null && rm cloudstats-agent-latest-linux-x86_64.tar.gz
COPY config.yml /home/cloudstats_agent/config.yml
RUN echo 'repo: agent007' >> /home/cloudstats_agent/config.yml
RUN /home/cloudstats_agent/cloudstats-agent --first-time

CMD '/home/cloudstats_agent/cloudstats-agent'
