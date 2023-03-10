FROM node:8

ENV APP_ROOT /app
ENV NODE_ENV production

WORKDIR ${APP_ROOT}

COPY package.json tsconfig.json ${APP_ROOT}/

RUN npm i && npm cache clean --force;

COPY src ${APP_ROOT}/src/

COPY config ${APP_ROOT}/config/

EXPOSE 8080 8081

CMD ["npm", "run", "start"]
