FROM node:latest

RUN npm install -g json-server && npm cache clean --force;

COPY ./ec2-metadata.json /root/ec2-metadata.json

ENTRYPOINT ["json-server", "/root/ec2-metadata.json"]
