FROM node:12.19.0
ADD ./index.html /
RUN npm install -g http-server && npm cache clean --force;
EXPOSE 9001
CMD http-server -p 9001
