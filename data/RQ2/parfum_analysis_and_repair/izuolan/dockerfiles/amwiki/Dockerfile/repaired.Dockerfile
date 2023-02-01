FROM node:alpine
RUN npm install -g amwiki && npm cache clean --force;
WORKDIR /wiki
CMD ["amwiki", "server"]
