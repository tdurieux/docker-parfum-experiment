FROM gcr.io/cloud-marketplace-tools/testrunner:0.1.4

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/kubectl/1.14 \
    && wget -q -O /opt/kubectl/1.14/kubectl \
       https://storage.googleapis.com/kubernetes-release/release/v1.14.8/bin/linux/amd64/kubectl \
    && chmod 755 /opt/kubectl/1.14/kubectl \
    && ln -s /opt/kubectl/1.14/kubectl /usr/bin/kubectl

COPY tests /tests
COPY tester.sh /tester.sh

WORKDIR /
ENTRYPOINT ["/tester.sh"]
