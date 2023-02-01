FROM node:6-slim
ADD . /
RUN npm install --ignore-scripts && npm cache clean --force;
CMD npm start
