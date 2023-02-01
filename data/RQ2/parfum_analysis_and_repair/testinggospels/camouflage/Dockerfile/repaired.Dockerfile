FROM node:alpine
WORKDIR /app
RUN npm install -g camouflage-server && npm cache clean --force;
RUN camouflage init
CMD ["camouflage", "--config", "config.yml"]