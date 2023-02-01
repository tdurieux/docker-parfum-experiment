FROM openjdk:11.0-jdk-stretch

RUN apt-get update && \
 apt-get install --no-install-recommends -y maven gradle && \
apt-get clean && rm -rf /var/lib/apt/lists/*;

ENV AGENT_TAG=jdk11

COPY agent_entry.sh /
COPY logging.properties /

COPY --from=checkmarxts/cxflow:latest /*.jar /

RUN chmod +x /agent_entry.sh && \
    mkdir /workspace && \
    chmod ugo+rwx /workspace

ENTRYPOINT ["/agent_entry.sh"]