FROM node:8-slim

WORKDIR /codelessAttachNode

COPY . /codelessAttachNode
RUN npm install && npm cache clean --force;
ENV PORT=1337
EXPOSE 1337
CMD [ "npm", "start" ]