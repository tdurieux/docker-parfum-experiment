FROM node:lts

RUN mkdir -p /etc/certs

RUN mkdir -p /project/app
COPY app /project/app
COPY package.json /project
COPY package-lock.json /project

WORKDIR /project
RUN chown -R node /project
RUN npm install && npm cache clean --force;

EXPOSE 4443

USER node
CMD ["npm", "start"]