FROM node:12
RUN npm -g install xcode-build-tools && npm cache clean --force;
