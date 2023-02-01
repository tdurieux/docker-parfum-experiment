FROM node:4
ADD . /
RUN npm install --ignore-scripts && npm cache clean --force;
CMD node broker.js
