FROM ubuntu

ENV PATH="$PATH:/usr/local/go/bin:/root/go/bin"

COPY hack/scripts/bootstrap.sh /tmp/bootstrap.sh
RUN chmod +x /tmp/bootstrap.sh
RUN /tmp/bootstrap.sh

COPY hack/scripts/devpool.sh /tmp/devpool.sh
RUN chmod +x /tmp/devpool.sh