# building heroprotocol -> parser -> hotsapi sequentially in a single container
FROM ubuntu:16.04

RUN apt update && \
	apt install --no-install-recommends -y python git && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /opt/heroprotocol
RUN git clone https://github.com/hotsapi/heroprotocol.git /opt/heroprotocol
RUN ln -s /opt/heroprotocol/heroprotocol.py /usr/bin/heroprotocol
ENTRYPOINT ['heroprotocol']
