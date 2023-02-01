FROM node:8

RUN npm install -g corsproxy && npm cache clean --force;

EXPOSE 1337

ENV CORSPROXY_HOST 0.0.0.0

ENTRYPOINT ["corsproxy"]