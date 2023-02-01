FROM node:8

RUN apt-get update && apt-get install --no-install-recommends -y cron rsyslog && rm -rf /var/lib/apt/lists/*;

ENV WORKDIR /usr/src/iot-raspi-sensors

RUN mkdir ${WORKDIR}

WORKDIR ${WORKDIR}

ADD scripts/ ${WORKDIR}

RUN chmod +x ${WORKDIR}/*.sh

RUN ${WORKDIR}/install-bcm.sh

COPY package*.json ${WORKDIR}/

RUN npm install --production && npm cache clean --force;

ADD dist/ ${WORKDIR}

RUN crontab ${WORKDIR}/crontab

CMD ${WORKDIR}/start.sh