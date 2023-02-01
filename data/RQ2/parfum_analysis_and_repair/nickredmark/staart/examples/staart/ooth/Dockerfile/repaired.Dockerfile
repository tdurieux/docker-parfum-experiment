FROM node:10

COPY package.json package-lock.json ./

RUN npm install && npm cache clean --force;

COPY . .

ENTRYPOINT [ "npm", "run" ]
CMD [ "start" ]
