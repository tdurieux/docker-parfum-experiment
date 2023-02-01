FROM jenkins

USER root

# Install dependencies for building node.
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    gcc \
    git && rm -rf /var/lib/apt/lists/*;

# Install node from source.
RUN wget https://nodejs.org/dist/v0.12.7/node-v0.12.7.tar.gz && \
    tar -zxf node-v0.12.7.tar.gz && \
    cd node-v0.12.7 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install && rm node-v0.12.7.tar.gz

RUN cd / && \
    rm node-v0.12.7.tar.gz && \
    rm -drf node-v0.12.7

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

USER jenkins
