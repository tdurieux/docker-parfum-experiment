FROM openjdk:8-slim
RUN apt-get update && apt-get install --no-install-recommends -y curl git ssh make bzr && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-6.6.2.tar.gz -o /tmp/bamboo.tar.gz && \
    cd /opt && tar zxf /tmp/bamboo.tar.gz && \
    mv atlassian-bamboo* bamboo && rm /tmp/bamboo.tar.gz
RUN curl -f -sSL https://minio.home.evanhazlett.com/public/containerd-buildkit.tar.gz -o /tmp/package.tar.gz && \
    tar zxf /tmp/package.tar.gz --strip-components=1 -C / && \
    rm -rf /tmp/package.tar.gz
COPY bamboo-init.properties /opt/bamboo/atlassian-bamboo/WEB-INF/classes/bamboo-init.properties
CMD ["/opt/bamboo/bin/start-bamboo.sh", "-fg"]
