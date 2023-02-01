FROM node:14
RUN npm i -D tap-junit@5.0.0 && npm cache clean --force;
WORKDIR /io
ENTRYPOINT [ "sh", "/node_modules/.bin/tap-junit" ]
