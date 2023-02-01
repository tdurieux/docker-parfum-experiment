FROM node:argon
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
RUN git clone http://github.com/aspnet/wave
WORKDIR /wave
RUN npm install && npm cache clean --force;
RUN ./scripts/write_version.sh
EXPOSE 8000
CMD node setup.js -h ${BROKER} -p ${PORT} -u ${USERNAME} -P ${PASSWORD} --id ${CLIENTID} && node app.js
