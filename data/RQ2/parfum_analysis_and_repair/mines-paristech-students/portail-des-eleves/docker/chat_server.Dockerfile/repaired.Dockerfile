FROM node:latest

WORKDIR /workspace
COPY . /workspace/
RUN npm install && npm cache clean --force;

CMD ["npm", "start"]