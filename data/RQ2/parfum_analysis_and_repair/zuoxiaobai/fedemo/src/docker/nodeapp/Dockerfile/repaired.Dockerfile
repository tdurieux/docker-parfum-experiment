FROM keymetrics/pm2:latest-alpine
WORKDIR /usr/src/app
ADD . /usr/src/app
RUN npm config set registry https://registry.npm.taobao.org/ && \
npm i && npm cache clean --force;
EXPOSE 3000
CMD ["pm2-runtime", "start", "process.yml"]
