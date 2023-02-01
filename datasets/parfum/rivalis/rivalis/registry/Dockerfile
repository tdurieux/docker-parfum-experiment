FROM node:16.14.0-alpine3.15

WORKDIR /opt/service

RUN npm install -g @rivalis/registry@2.5.31

ENV REGISTRY_HTTP_PORT 26000

CMD ["sh", "-c", "rivalis-registry"]