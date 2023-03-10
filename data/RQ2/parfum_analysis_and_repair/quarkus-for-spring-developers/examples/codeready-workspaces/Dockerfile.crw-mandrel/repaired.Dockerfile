FROM registry.redhat.io/codeready-workspaces/plugin-java11-rhel8:latest

USER root

# Install dependencies for mandrel
RUN dnf install -y glibc-devel zlib-devel gcc glibc-static

# Get and install mandrel
RUN wget https://github.com/graalvm/mandrel/releases/download/mandrel-21.1.0.0-Final/mandrel-java11-linux-amd64-21.1.0.0-Final.tar.gz && \
    gzip -dc mandrel-java11-linux-amd64-21.1.0.0-Final.tar.gz | tar xvf - && \
    mv mandrel-java11-21.1.0.0-Final /opt && \
    rm -rf mandrel-java11-21.1.0.0-Final

ENV GRAALVM_HOME=/opt/mandrel-java11-21.1.0.0-Final

USER jboss