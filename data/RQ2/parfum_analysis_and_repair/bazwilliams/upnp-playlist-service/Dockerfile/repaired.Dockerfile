FROM node:4-slim

ENV PORT=3000
ENV DATA_LOCATION=/data

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN npm install --production --quiet && npm cache clean --force;

ENTRYPOINT [ "npm", "run-script" ]

CMD [ "start" ]
