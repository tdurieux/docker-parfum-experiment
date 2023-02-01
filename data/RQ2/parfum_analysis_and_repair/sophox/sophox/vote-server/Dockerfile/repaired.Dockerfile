FROM node:10.11-alpine
LABEL maintainer='Yuri Astrakhan <YuriAstrakhan@gmail.com>'

WORKDIR /app

COPY package*.json ./

RUN npm install -g -s --no-progress yarn && \
    yarn && \
    yarn cache clean && npm cache clean --force;

COPY . .

EXPOSE 9979
CMD [ "yarn", "start" ]
