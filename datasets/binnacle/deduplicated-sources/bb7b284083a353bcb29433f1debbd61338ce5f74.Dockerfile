FROM node:6-slim
ADD . /
RUN npm install --ignore-scripts
CMD npm start
