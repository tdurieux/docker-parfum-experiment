# production dockerfile
FROM node:7.6.0

# add code
COPY . /backend

WORKDIR /backend

#install deps, build, remove initial sources, dev deps
RUN npm i -q && \
    npm run compile && \
    npm prune -q --production && npm cache clean --force;

#migrate & run
CMD ./node_modules/.bin/sequelize db:migrate && \
    npm run serve
