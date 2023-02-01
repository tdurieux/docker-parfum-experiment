FROM maven:3-jdk-11

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo wget nano nodejs && rm -rf /var/lib/apt/lists/*;

CMD tail -f /dev/null
