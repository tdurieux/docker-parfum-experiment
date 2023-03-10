FROM node:12-alpine

WORKDIR /usr/src/app

COPY package*.json \
  tsconfig*.json \
  yarn.lock \
  ./

RUN yarn && yarn cache clean;

ARG URL
ARG DB_HOST
ARG DB_USER
ARG DB_PASSWORD
ARG DB_NAME
ARG MAIL_SERVICE
ARG MAIL_USER
ARG MAIL_PASS
ENV URL ${URL}
ENV DB_HOST ${DB_HOST}
ENV DB_USER ${DB_USER}
ENV DB_PASSWORD ${DB_PASSWORD}
ENV DB_NAME ${DB_NAME}
ENV MAIL_SERVICE ${MAIL_SERVICE}
ENV MAIL_USER ${MAIL_USER}
ENV MAIL_PASS ${MAIL_PASS}

COPY . .


RUN yarn build && yarn cache clean;


RUN yarn migration:run && yarn cache clean;


CMD ["yarn", "start"]
