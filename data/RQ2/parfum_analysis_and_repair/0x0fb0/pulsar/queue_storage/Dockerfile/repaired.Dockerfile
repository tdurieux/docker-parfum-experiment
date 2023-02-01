FROM rabbitmq:3.8-rc
RUN apt-get update \
    && apt-get install --no-install-recommends -y screen netcat \
	&& mkdir -p /home/testca/certs \
	&& mkdir -p /home/testca/private \
	&& chmod 700 /home/testca/private \
	&& echo 01 > /home/testca/serial \
	&& touch /home/testca/index.txt && rm -rf /var/lib/apt/lists/*;

COPY rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
COPY openssl.cnf /home/testca
COPY prepare-server.sh generate-client-keys.sh /home/

RUN mkdir -p /certs \
    && mkdir -p /home/server \
	&& mkdir -p /home/client \
	&& chmod +x /home/prepare-server.sh /home/generate-client-keys.sh

RUN /bin/bash /home/prepare-server.sh
#WORKDIR /home/client
RUN /bin/bash /home/generate-client-keys.sh
