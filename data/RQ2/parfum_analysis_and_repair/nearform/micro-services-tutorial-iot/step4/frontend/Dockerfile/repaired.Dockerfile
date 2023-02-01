FROM node:4
ADD . /
RUN cd api && npm install --ignore-scripts && npm cache clean --force;
CMD node api/index.js
