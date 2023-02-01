FROM node:16.14.2

WORKDIR /workspace
COPY ["package.json", "package-lock.json", "app.js", "./"]
RUN npm i && npm cache clean --force;
ENTRYPOINT ["node", "app.js"]
