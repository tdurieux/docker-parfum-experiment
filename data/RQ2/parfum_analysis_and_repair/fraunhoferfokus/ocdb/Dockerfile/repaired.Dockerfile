FROM node:0.10-slim

# https://github.com/fraunhoferfokus/OCDB

WORKDIR /root/ocdb

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install wget apg netcat git curl && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/fraunhoferfokus/ocdb /root/ocdb

RUN npm install && npm cache clean --force;

RUN mkdir -p db/mongodb/bin && \
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.6.6.tgz -P /tmp/ && \
    tar -xvf /tmp/mongodb-linux-x86_64-2.6.6.tgz --strip-components 2 -C db/mongodb/bin mongodb-linux-x86_64-2.6.6/bin && rm /tmp/mongodb-linux-x86_64-2.6.6.tgz

EXPOSE 443

COPY boot.sh /root/ocdb/

CMD ["/root/ocdb/boot.sh"]
