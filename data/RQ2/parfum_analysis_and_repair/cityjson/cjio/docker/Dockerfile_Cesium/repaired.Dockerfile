FROM node:8

RUN mkdir /opt/cesium; \
    wget https://github.com/AnalyticalGraphicsInc/cesium/releases/download/1.56.1/Cesium-1.56.1.zip -O /opt/cesium.zip -nv; \
    unzip /opt/cesium.zip -d /opt/cesium; \
    rm /opt/cesium.zip; \
    cd /opt/cesium; \
    npm install && npm cache clean --force;

WORKDIR /opt/cesium
EXPOSE 8080
CMD ["npm", "start"]

