FROM node:dubnium-stretch
RUN mkdir -p /home/node/app/node_modules && \
    chown -R node:node /home/node/app && \
    apt-get update && \
    apt-get install --no-install-recommends -y kafkacat && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/node/app
COPY package*.json ./
USER node
RUN npm install && npm cache clean --force;
COPY --chown=node:node . .
EXPOSE 3000
CMD [ "bash", "start.sh" ]
