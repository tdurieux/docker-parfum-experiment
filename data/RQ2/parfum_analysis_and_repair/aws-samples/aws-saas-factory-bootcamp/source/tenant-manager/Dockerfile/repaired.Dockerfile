FROM public.ecr.aws/bitnami/node:10-prod

WORKDIR /usr/src/app
RUN mkdir tenant-manager shared-modules

COPY shared-modules shared-modules/
COPY package*.json server.js tenant-manager/

RUN cd shared-modules && for SHARED_MODULE in $(ls -d ./*); do cd $SHARED_MODULE && npm install && cd ..; done && npm cache clean --force;
RUN cd tenant-manager && npm install && npm cache clean --force;

ENV NODE_ENV=production
ENV NODE_CONFIG_DIR=/usr/src/app/shared-modules/config-helper/config/

CMD ["node", "./tenant-manager/server.js"]

EXPOSE 3003