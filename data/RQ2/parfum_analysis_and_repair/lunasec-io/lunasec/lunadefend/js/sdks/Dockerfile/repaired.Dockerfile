FROM node:14

RUN npm install -g npm@^7 && npm cache clean --force;

RUN mkdir /work

COPY . /work

WORKDIR /work

RUN npm install && npm cache clean --force;

ENTRYPOINT ["npm", "run", "compile"]


