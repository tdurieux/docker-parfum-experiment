FROM node
ADD . /
RUN npm install --ignore-scripts && npm cache clean --force;
CMD node actuator.js

