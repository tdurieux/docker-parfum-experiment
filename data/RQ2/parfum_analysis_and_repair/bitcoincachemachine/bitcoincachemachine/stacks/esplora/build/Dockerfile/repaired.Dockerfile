FROM node

RUN apt-get update && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/Blockstream/esplora /root/esplora
WORKDIR /root/esplora
RUN git checkout tags/esplora_v2.10

RUN npm install && npm cache clean --force;

ADD ./entrypoint.sh /entrypoint.sh
RUN chmod 0755 /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]