FROM ubuntu:18.04
MAINTAINER Deborah Sandoval <Deborah.Sandoval@microsoft.com>

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.5 \
    python3-pip

RUN pip3 install wheel
RUN pip3 install setuptools
RUN pip3 install requests
RUN pip3 install cachetools
RUN pip3 install tabulate

COPY run.sh /
RUN chmod +x /run.sh

ADD RepairManager /DLWorkspace/src/RepairManager

RUN pip3 install -r /DLWorkspace/src/RepairManager/requirements.txt

CMD /run.sh
