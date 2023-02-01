FROM node:latest
RUN npm install -g http-server && npm cache clean --force;
CMD http-server ./ --cors
