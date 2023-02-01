FROM glanf/base
MAINTAINER Kyle White

RUN apt-get install --no-install-recommends -y \
    python \
    scapy \
    tcpdump \
    python-nfqueue \
    build-essential \
    python-dev \
    libnetfilter-queue-dev \
    python-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir netfilterqueue
RUN pip install --no-cache-dir requests

RUN mkdir data
ADD main.py ./data/
RUN chmod +x ./data/main.py

ENTRYPOINT ifinit && \
	brinit && \
	iptables -A FORWARD -j NFQUEUE -p tcp --destination-port 80 --queue-num 1 && \
	python ./data/main.py
