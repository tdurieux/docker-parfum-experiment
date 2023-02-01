FROM ideolys/carbone-env-docker

ENV DIR /app
WORKDIR ${DIR}
COPY app ${DIR}
RUN npm install && npm cache clean --force;

CMD [ "node", "index.js" ]
