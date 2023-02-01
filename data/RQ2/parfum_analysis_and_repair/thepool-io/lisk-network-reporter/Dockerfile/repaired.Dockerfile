FROM node:8.1.2
RUN apt-get update && apt-get install -y --no-install-recommends sudo && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/karek314/lisk-network-reporter/
ADD ./postinstall.sh /
RUN chmod +x /postinstall.sh
ENTRYPOINT /postinstall.sh
WORKDIR /lisk-network-reporter
