FROM node:gallium-alpine
COPY . /app
WORKDIR /app
RUN npm install && npm cache clean --force;
ENTRYPOINT [ "npm", "run", "start:debug" ]
