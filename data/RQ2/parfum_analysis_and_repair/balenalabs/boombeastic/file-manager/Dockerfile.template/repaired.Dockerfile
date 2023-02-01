FROM balenalib/%%BALENA_MACHINE_NAME%%-node:12-run

# Move to app dir
RUN mkdir -p /usr/src/app/ && rm -rf /usr/src/app/
WORKDIR /usr/src/app
COPY ./app/package.json ./

RUN npm install --unsafe-perm -g node-file-manager && npm cache clean --force;
RUN JOBS=MAX npm install --unsafe-perm --production && npm cache clean --force;
RUN npm cache clean --force && rm -rf /tmp/*

# Move app to filesystem
COPY ./app ./

# Start app
CMD ["bash", "/usr/src/app/start.sh"]
