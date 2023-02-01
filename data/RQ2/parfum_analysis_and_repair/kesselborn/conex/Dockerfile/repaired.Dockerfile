FROM node
RUN npm install --global web-ext && npm cache clean --force;
