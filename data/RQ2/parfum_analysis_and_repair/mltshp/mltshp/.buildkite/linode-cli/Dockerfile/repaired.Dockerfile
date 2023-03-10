FROM ubuntu

RUN apt-get update \
    && apt-get install --no-install-recommends -y wget lsb-release \
    && echo "deb http://apt.linode.com/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/linode.list \
    && (wget -O- https://apt.linode.com/linode.gpg | apt-key add -) \
    && apt-get update \
    && apt-get install --no-install-recommends -y linode-cli && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/bin/linode"]
