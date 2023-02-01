FROM node:latest
RUN npm i -g redis-commander && npm cache clean --force;
EXPOSE 8081
#CMD ["redis-commander"]
