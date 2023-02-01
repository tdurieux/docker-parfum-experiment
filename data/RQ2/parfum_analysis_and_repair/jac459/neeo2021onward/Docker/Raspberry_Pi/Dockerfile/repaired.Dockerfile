#FROM ubuntu:latest
FROM arm32v7/python:2.7.13-jessie

VOLUME /data
#VOLUME /config

RUN apt update
RUN apt install --no-install-recommends -y tzdata apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install curl gnupg && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN mkdir -p /opt/meta
#RUN mkdir -p /opt/.npm

WORKDIR /opt/meta

RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;
RUN apt-get install --no-install-recommends -y mosquitto && rm -rf /var/lib/apt/lists/*;
#RUN apt install dumb-init
RUN npm install -g --unsafe-perm node-red && npm cache clean --force;

RUN mkdir -p /home
RUN mkdir -p /home/meta
RUN mkdir -p /home/meta/.meta
RUN chown -R 1000:1000 "/home/meta/.meta"

RUN npm install pm2 -g && npm cache clean --force;
RUN useradd -u 1000 -U -p "$(openssl passwd -1 meta)"  -d /config -s /bin/false meta
RUN usermod -G users meta
RUN adduser meta sudo

RUN mkdir -p /config
RUN mkdir -p /config/meta
RUN mkdir -p /opt
RUN mkdir -p /opt/meta
RUN mkdir -p /config/.pm2
RUN chown -R 1000:1000 "/config"
RUN chown -R 1000:1000 "/opt/meta"

RUN pm2 startup
              # Run this command as root, it sets up starting PM2, that needs to be done with root

WORKDIR /opt/meta
  # now we can continue as user = meta
USER meta

RUN npm install --no-color --prefix "/opt/meta/"  jac459/metadriver && npm cache clean --force;
RUN pm2 start /opt/meta/node_modules/@jac459/metadriver/meta.js
RUN pm2 start mosquitto
RUN pm2 start node-red

# uncomment next command to prevent autodiscovery of brain
#COPY config/config.js /opt/meta/node_modules/@jac459/metadriver/config.js
COPY scripts/startup.sh /scripts/startup.sh
#COPY flows_cred.json /data/flows_cred.json
#COPY flows.json /data/flows.json

# Add configuration and scripts
#ADD startup/ /etc/meta/

ENV OPENVPN_USERDIR=**None**
EXPOSE 1880-1883
EXPOSE 3000
expose 4000-4100
RUN pm2 save
# Expose port and run
#CMD ["dumb-init", "bash -c 'sleep 99m'"]
#CMD /usr/bin/node /opt/meta/node_modules/@jac459/metadriver/meta.js
CMD "/scripts/startup.sh"
