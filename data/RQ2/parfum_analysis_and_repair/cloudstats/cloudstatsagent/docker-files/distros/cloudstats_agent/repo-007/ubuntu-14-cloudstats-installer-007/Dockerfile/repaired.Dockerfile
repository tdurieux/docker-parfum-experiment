FROM ubuntu:14.04

RUN apt-get update && apt-get install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

RUN bash -lc "curl https://cloudstatsstorage.blob.core.windows.net/agent007/installer | bash -s cmBS5j5hvkrc-0mv2uLVtol8kdhAzw4uAVSy9QrbSRUBCKtRyK5-jzfisrDUfntmQpgkNupCQPu5GIG23be1FXw"
RUN echo 'repo: agent007' >> /home/cloudstats_agent/config.yml


RUN echo 'ubu14-cld-inst-007' > /etc/cloudstats/server.key
RUN /home/cloudstats_agent/cloudstats-agent --first-time

CMD '/home/cloudstats_agent/cloudstats-agent'
