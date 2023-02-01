FROM node:slim
ENV NODE_ENV dev
RUN mkdir -p /var/app
COPY . /var/app
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN cd /var/app/watcher && npm update && \
        npm install --silent && npm cache clean --force;
RUN cd /var/app/webapp && npm update && \
        npm install --silent && npm cache clean --force;
WORKDIR /var/app/watcher
ENV NODE_ENV=production
CMD ["node", "server.js"]
