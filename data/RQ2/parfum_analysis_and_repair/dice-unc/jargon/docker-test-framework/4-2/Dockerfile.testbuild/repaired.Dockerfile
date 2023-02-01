#
# Unit test and build container
#
FROM maven:3.6.3-jdk-11

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo wget nano && rm -rf /var/lib/apt/lists/*;



CMD tail -f /dev/null