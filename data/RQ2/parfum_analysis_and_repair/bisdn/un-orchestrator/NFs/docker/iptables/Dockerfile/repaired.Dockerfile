FROM      ubuntu
MAINTAINER Politecnico di Torino

RUN apt-get update && apt-get install --no-install-recommends -y iptables bridge-utils && rm -rf /var/lib/apt/lists/*;

ADD start.sh start.sh
RUN chmod +x start.sh

CMD ./start.sh
