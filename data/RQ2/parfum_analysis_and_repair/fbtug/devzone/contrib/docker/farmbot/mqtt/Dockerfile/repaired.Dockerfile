FROM node:7
WORKDIR /opt
RUN git clone --depth=1 https://github.com/FarmBot/mqtt-gateway.git && \
    cd mqtt-gateway && npm install && npm cache clean --force;
WORKDIR /opt/mqtt-gateway
