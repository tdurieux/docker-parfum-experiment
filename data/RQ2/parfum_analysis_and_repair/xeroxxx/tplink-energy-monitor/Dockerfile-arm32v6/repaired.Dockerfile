FROM arm32v6/node:alpine
COPY qemu-arm-static /usr/bin
WORKDIR /opt/tplink-monitor

COPY package.json .
RUN npm install && npm cache clean --force;
RUN npm audit fix -force

COPY logger-config.json .
COPY src src

EXPOSE 3000
CMD ["npm", "start"]