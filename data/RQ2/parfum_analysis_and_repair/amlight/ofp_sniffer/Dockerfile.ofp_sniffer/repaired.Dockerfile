FROM ubuntu:16.04
LABEL maintainer "dev@amlight.net"

CMD ["/bin/bash"]

# ofp_sniffer app dir
ENV DIR /opt/ofp_sniffer
WORKDIR $DIR

ENV DEBIAN_FRONTEND=noninteractive
# Python 3.6 repo
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common \
 && add-apt-repository -y ppa:jonathonf/python-3.6 && rm -rf /var/lib/apt/lists/*;
# Install python 3.6 and libpcap c headers dependencies
RUN apt-get update && apt-get install --no-install-recommends -y python3.6 python3.6-dev python3.6-venv libpcap-dev build-essential && rm -rf /var/lib/apt/lists/*;

# Bootstrap pip3.6 on Ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python3.6 get-pip.py

# Python requirements
COPY docs/requirements.txt $DIR
RUN /usr/local/bin/pip install -r requirements.txt
