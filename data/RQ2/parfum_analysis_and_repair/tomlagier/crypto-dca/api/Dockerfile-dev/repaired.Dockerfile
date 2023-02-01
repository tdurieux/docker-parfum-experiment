FROM mhart/alpine-node:9
WORKDIR www/
RUN npm install && npm cache clean --force;
CMD npm run watch