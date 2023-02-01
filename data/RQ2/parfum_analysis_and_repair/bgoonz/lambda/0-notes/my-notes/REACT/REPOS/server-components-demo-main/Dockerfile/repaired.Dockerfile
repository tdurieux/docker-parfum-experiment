FROM node:14.16.0


WORKDIR /opt/notes-app

COPY package.json package-lock.json ./

RUN npm install && npm cache clean --force;

COPY . .

ENTRYPOINT [ "npm", "run" ]
CMD [ "start" ]
