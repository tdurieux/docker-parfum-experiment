FROM funkygibbon/ubuntu

MAINTAINER Ray Walker <hello@raywalker.it>

# install java
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
     openjdk-7-jre-headless && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;