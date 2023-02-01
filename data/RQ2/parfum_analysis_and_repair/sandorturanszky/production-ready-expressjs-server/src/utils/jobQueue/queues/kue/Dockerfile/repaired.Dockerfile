FROM mhart/alpine-node:10

ENV NODE_ENV=production

# Create app directory
WORKDIR /usr/src/app

RUN npm install kue && npm cache clean --force;
RUN npm install config && npm cache clean --force;
RUN npm install winston && npm cache clean --force;
RUN npm install morgan && npm cache clean --force;
RUN npm install app-root-path && npm cache clean --force;

# Copy certain folders and files
COPY ./config /config
COPY ./src /src

EXPOSE 3050
CMD ["node", "./src/utils/jobQueue/queues/kue/dashboard.js"]
