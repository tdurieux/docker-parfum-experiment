# Set the base image to Ubuntu16.04
FROM ubuntu:16.04

MAINTAINER frank-xjh "frank99-xu@outlook.com"

WORKDIR /
RUN apt-get update \
    && apt-get install --no-install-recommends -y git wget curl python3 python3-pip gcc g++ make \
	&& curl -f https://bootstrap.pypa.io/get-pip.py | python3 \
    && curl -f -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/24OI/OI-wiki.git --depth=1 \
    && cd OI-wiki \
    && pip install --no-cache-dir -U -r requirements.txt \
    && npm install && npm cache clean --force;

ADD .bashrc /root/

WORKDIR /OI-wiki
EXPOSE 8000
CMD ["/bin/bash"]
