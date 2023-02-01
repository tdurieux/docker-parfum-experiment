FROM node:16-buster-slim

ENV NODE_ENV=production

RUN addgroup inmate && \
adduser --disabled-password --gecos "" --ingroup inmate inmate

WORKDIR /home/inmate/app
COPY . ./

RUN chown -R inmate:inmate .
USER inmate
RUN npm install && npm cache clean --force;

CMD ["node", "./app.js"]
