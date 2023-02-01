FROM node:6

RUN npm install -g @angular/cli && npm cache clean --force;

EXPOSE 80
