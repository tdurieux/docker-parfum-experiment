FROM ubuntu:18.04
MAINTAINER Deborah Sandoval <Deborah.Sandoval@microsoft.com>

RUN apt-get update && apt-get --no-install-recommends install -y \
    python3.5 \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir setuptools
RUN pip3 install --no-cache-dir requests

COPY kubectl /usr/local/bin/kubectl
RUN chmod +x /usr/local/bin/kubectl

COPY run.sh /
RUN chmod +x /run.sh

ADD RepairManager /DLWorkspace/src/RepairManager

RUN pip3 install --no-cache-dir -r /DLWorkspace/src/RepairManager/requirements.txt

CMD /run.sh
