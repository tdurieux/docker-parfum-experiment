FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y net-tools iputils-ping telnet ssh tcpdump nmap dsniff && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl iperf3 netperf ethtool python-scapy python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iptables bridge-utils apache2 vim && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir flask

ADD flask/http_test.py /
COPY entrypoint.sh /entrypoint.sh

RUN echo "secret file" >> secret.txt
RUN echo "plain file" >> plain.txt

RUN mkdir /credentials
RUN echo "password file" >> /credentials/password
RUN echo "token file" >> /credentials/token

RUN mkdir -p /credentials/keys
RUN echo "cert file" >> /credentials/keys/cert.ca
RUN echo "key file" >> /credentials/keys/priv.key

CMD [ "/entrypoint.sh" ]
