FROM node:12

RUN mkdir /app
WORKDIR /app

COPY cgroup-metrics-*.tgz .
RUN npm install cgroup-metrics-*.tgz && npm cache clean --force;

COPY stress.sh .
COPY app.js .

CMD ./stress.sh; node app.js