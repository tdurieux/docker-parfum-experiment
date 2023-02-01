FROM node:slim
ENV NODE_ENV dev
RUN mkdir -p /var/app
COPY . /var/app
RUN apt-get update && apt-get install --no-install-recommends -y git python build-essential && rm -rf /var/lib/apt/lists/*;
RUN npm install -g bower && npm cache clean --force;
RUN echo '{ "allow_root": true }' > /root/.bowerrc
RUN cd /var/app/watcher && npm update && \
        npm install --silent && npm cache clean --force;
RUN cd /var/app/webapp && npm update && \
        npm install --silent && \
        bower install && \
        npm rebuild bcrypt --build-from-source && npm cache clean --force;
WORKDIR /var/app/webapp
ENV NODE_ENV=development
ENV DEBUG=express:*
CMD ["node", "server.js"]
