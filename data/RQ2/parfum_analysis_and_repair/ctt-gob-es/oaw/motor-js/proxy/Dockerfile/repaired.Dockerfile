FROM node:9.5.0-alpine

#Instalamos dependencias necesarias
RUN npm install request --save && npm cache clean --force;
RUN npm install regex --save && npm cache clean --force;

#Copiamos el prerrender
COPY index.js /opt/proxy/index.js