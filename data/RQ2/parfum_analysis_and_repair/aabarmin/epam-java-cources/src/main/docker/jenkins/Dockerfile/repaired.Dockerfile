FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;

COPY ./analyzer.py /opt/analyzer.py