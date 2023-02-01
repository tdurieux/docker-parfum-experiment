FROM  mhart/alpine-node:latest
WORKDIR /srv/acharh
RUN npm i express@5.0.0-alpha.5 && npm cache clean --force;
RUN npm i compression && npm cache clean --force;
RUN npm i morgan && npm cache clean --force;
ADD dist/ /srv/acharh/
CMD ["node","server.js"]
