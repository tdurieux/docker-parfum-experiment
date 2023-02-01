FROM node:16

WORKDIR /usr/src/app

COPY sdk/ /tmp/sdk

RUN cd /tmp/sdk && \
 npm install && \
 npm run build && \
 npm pack && \
 mv apache-flink-statefun-*.tgz /usr/src/app/apache-flink-statefun.tgz && \
 cd /usr/src/app && npm cache clean --force;

COPY remote-function/* /usr/src/app/

RUN npm install && npm cache clean --force;

EXPOSE 8000

CMD ["node", "/usr/src/app/smoke.js"]
