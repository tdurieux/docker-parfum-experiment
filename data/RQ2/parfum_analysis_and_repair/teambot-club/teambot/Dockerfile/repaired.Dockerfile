FROM node:6.9.1
ADD . /app
ENV NODE_ENV production
WORKDIR /app
RUN apt-get update \
    && apt-get install --no-install-recommends -y libstdc++-4.9-dev && rm -rf /var/lib/apt/lists/*;
RUN npm install bower -g && npm cache clean --force;
RUN npm install --unsafe-perm && npm cache clean --force;
CMD node teambot.js --mongo mongodb://mongo:27017 --production
