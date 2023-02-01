FROM node:16.14.0-alpine3.15

RUN apk add --update --no-cache python3 make g++
RUN ln -sf python3 /usr/bin/python

WORKDIR /opt/service

RUN npm install -g @rivalis/console@1.3.8

ENV CONSOLE_API_PORT 2334
ENV CONSOLE_ENABLE_WEBAPP true
ENV CONSOLE_ENV production
ENV CONSOLE_API_DB_DIALECT sqlite

CMD ["sh", "-c", "rivalis-console"]