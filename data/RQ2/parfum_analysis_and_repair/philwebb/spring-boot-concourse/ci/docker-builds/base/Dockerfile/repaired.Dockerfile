FROM java:8-jdk

RUN \
 apt-get update && \
 apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
