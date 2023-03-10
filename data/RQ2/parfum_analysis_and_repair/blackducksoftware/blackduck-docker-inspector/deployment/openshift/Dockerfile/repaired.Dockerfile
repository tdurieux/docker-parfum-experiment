FROM ubuntu:latest
RUN apt-get update -y && apt-get install --no-install-recommends -y openjdk-8-jdk vim curl dnsutils && apt-get -y clean && rm -rf /var/lib/apt/lists/*;
RUN touch /usr/local/bin/docker
RUN chmod a+rx /usr/local/bin/docker
RUN mkdir -p /opt/blackduck/detect/blackduck
RUN mkdir -p /opt/blackduck/shared/target
RUN chmod 777 /opt/blackduck/detect/blackduck
