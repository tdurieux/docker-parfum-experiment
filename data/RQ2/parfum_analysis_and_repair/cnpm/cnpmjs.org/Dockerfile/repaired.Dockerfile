FROM node:12
MAINTAINER Bono Lv <lvscar  {aT} gmail.com>

# Working enviroment
ENV \
    CNPM_DIR="/var/app/cnpmjs.org" \
    CNPM_DATA_DIR="/var/data/cnpm_data"

RUN mkdir  -p ${CNPM_DIR}

WORKDIR ${CNPM_DIR}

COPY package.json ${CNPM_DIR}

RUN npm set registry https://registry.npmmirror.com

RUN npm install --production && npm cache clean --force;

COPY .  ${CNPM_DIR}
COPY docs/dockerize/config.js  ${CNPM_DIR}/config/

EXPOSE 7001/tcp 7002/tcp

VOLUME ["/var/data/cnpm_data"]

# Entrypoint
CMD ["node", "dispatch.js"]

