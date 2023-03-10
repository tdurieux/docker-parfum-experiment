FROM arm64v8/node:alpine
COPY qemu-aarch64-static /usr/bin
WORKDIR /opt/tplink-monitor

COPY package.json .
RUN npm install && npm cache clean --force;
RUN npm audit fix -force

COPY logger-config.json .
COPY src src

EXPOSE 3000
CMD ["npm", "start"]