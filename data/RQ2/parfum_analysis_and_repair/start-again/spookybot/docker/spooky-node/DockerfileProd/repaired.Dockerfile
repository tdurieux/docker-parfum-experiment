ARG NODE_VERSION

FROM node:${NODE_VERSION}

COPY . /spooky

WORKDIR /spooky
RUN npm cache clean --force
RUN rm -rf node_modules
RUN npm install --production && npm cache clean --force;

RUN rm -rf app/config
RUN rm -rf app/db
ENTRYPOINT ["npm", "run", "start"]
