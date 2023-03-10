FROM balenalib/%%BALENA_MACHINE_NAME%%-node:8

WORKDIR /usr/src/app

COPY package.json package-lock.json ./

RUN npm install --ci --production \
    && npm cache clean --force \
    && rm -rf /tmp/*

COPY src/ ./src/

CMD ["npm", "start"]