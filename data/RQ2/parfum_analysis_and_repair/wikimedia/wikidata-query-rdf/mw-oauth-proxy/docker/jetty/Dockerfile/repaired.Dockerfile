FROM jetty:9.4-jdk8-slim

USER root
RUN apt update && apt install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;

USER jetty
