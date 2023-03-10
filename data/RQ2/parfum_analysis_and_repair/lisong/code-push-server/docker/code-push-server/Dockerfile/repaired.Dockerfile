FROM node:8.11.4-alpine

RUN npm config set registry https://registry.npm.taobao.org/ \
&& npm i -g code-push-server@0.5.2 pm2@latest --no-optional && npm cache clean --force;

COPY ./process.json /process.json

EXPOSE 3000

CMD ["pm2-docker", "start", "/process.json"]
