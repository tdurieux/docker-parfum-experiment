FROM node:8.12-slim

ENV DIR /opt/admin-web
RUN mkdir -p ${DIR}/
EXPOSE 3001

WORKDIR $DIR

ENTRYPOINT npm start