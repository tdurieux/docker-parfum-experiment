FROM node:8

ENV WORKDIR /usr/src/iot-raspi-sensors-server

RUN mkdir ${WORKDIR}

WORKDIR ${WORKDIR}

ADD scripts/ ${WORKDIR}

RUN chmod +x ${WORKDIR}/*.sh

RUN ${WORKDIR}/install-bcm.sh

COPY package*.json ${WORKDIR}/

RUN npm install --production && npm cache clean --force;

ADD dist ${WORKDIR}

CMD ["npm", "run", "production:server"]