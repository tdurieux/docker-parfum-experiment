FROM centos:latest

RUN curl -f https://monitoringagent.blob.core.windows.net/agent/monitoring-installer | sh -s cmBS5j5hvkrc-0mv2uLVtol8kdhAzw4uAVSy9QrbSRUBCKtRyK5-jzfisrDUfntmQpgkNupCQPu5GIG23be1FXw
RUN /home/monitoring_agent/monitoring-agent --first-time

CMD '/home/monitoring_agent/monitoring-agent'
