FROM node
ADD . /
RUN cd api && npm install && npm cache clean --force;
CMD node /api/index.js
