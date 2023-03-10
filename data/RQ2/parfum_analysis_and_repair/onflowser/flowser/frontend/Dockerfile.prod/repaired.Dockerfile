FROM node:16-alpine3.12 as production

# set the working direction
WORKDIR /app

ARG NODE_ENV=production
ARG REACT_APP_FLOW_DISCOVERY_WALLET
ARG REACT_APP_FLOW_ACCESS_NODE
ARG REACT_APP_API_HOST=https://app.flowser.dev
ARG REACT_APP_URL=http://localhost:3000

ENV NODE_ENV=${NODE_ENV}
ENV REACT_APP_FLOW_DISCOVERY_WALLET=${REACT_APP_FLOW_DISCOVERY_WALLET}
ENV REACT_APP_FLOW_ACCESS_NODE=${REACT_APP_FLOW_ACCESS_NODE}
ENV REACT_APP_API_HOST=${REACT_APP_API_HOST}
ENV REACT_APP_URL=${REACT_APP_URL}

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# install app dependencies
COPY . .
RUN npm install && npm cache clean --force;

RUN npm run build
RUN npm i -g serve && npm cache clean --force;

# Rewrite all not-found requests to `index.html` with -s option
CMD serve build -s -p ${APP_FRONTEND_PORT}
