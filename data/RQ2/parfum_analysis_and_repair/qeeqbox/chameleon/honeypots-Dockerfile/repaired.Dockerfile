FROM python:3.8
RUN echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections && \
	echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections && \
	apt-get update -y && apt-get install --no-install-recommends -y iptables-persistent tcpdump nmap iputils-ping libpq-dev python3-psycopg2 lsof psmisc dnsutils libffi-dev libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir honeypots==0.34
WORKDIR app
COPY config.json .
ARG PORTS
EXPOSE ${PORTS}
ENTRYPOINT ["python3","-m","honeypots","--chameleon","--config","config.json", "--sniffer"]
