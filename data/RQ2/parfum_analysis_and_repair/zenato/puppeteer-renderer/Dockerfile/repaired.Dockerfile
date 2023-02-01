FROM zenato/puppeteer

USER root

COPY . /app

RUN cd /app && npm install --quiet && npm cache clean --force;

EXPOSE 3000

WORKDIR /app

CMD npm run start
