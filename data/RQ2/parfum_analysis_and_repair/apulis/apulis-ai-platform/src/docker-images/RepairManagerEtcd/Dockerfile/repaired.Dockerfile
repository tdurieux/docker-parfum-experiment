FROM ubuntu:18.04
MAINTAINER Deborah Sandoval <Deborah.Sandoval@microsoft.com>

RUN apt-get update && apt-get --no-install-recommends install -y \
    etcd-server && rm -rf /var/lib/apt/lists/*;

COPY run.sh /
RUN chmod +x /run.sh

CMD /run.sh
