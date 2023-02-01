FROM      ubuntu
MAINTAINER Politecnico di Torino

RUN apt-get update && apt-get install --no-install-recommends -y iptables && rm -rf /var/lib/apt/lists/*;

ADD sysctl.conf /etc/sysctl.conf
ADD ./start_nat.sh start_nat.sh

RUN chmod +x start_nat.sh

CMD ./start_nat.sh
