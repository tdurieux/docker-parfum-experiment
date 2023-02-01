FROM ubuntu:18.04
MAINTAINER Deborah Sandoval <Deborah.Sandoval@microsoft.com>

RUN apt-get update && apt-get --no-install-recommends install -y \
    python3.7 \
    python3-pip \
    systemd-sysv && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir wheel setuptools requests

# separate line as pyyaml has dependency on setuptools
RUN pip3 install --no-cache-dir pyyaml

COPY run.sh /
RUN chmod +x /run.sh

ADD RepairManagerAgent /DLWorkspace/src/RepairManagerAgent

CMD /run.sh
