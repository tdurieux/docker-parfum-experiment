# https://github.com/danielgtaylor/aglio/blob/master/Dockerfile
FROM node:0.12.7

RUN npm install -g aglio && npm cache clean --force;

ENTRYPOINT ["aglio"]
