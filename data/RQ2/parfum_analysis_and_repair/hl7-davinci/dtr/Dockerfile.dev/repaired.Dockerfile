FROM node:14-alpine
WORKDIR /home/node/app/dtr
COPY --chown=node:node . .
RUN npm install && npm cache clean --force;
EXPOSE 3005
EXPOSE 3006
CMD ./dockerRunnerDev.sh
