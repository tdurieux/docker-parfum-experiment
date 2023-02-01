FROM node:12-alpine
COPY package.json .
RUN npm set progress=false
RUN npm install --only=production && npm cache clean --force;
COPY ./build ./build
ENTRYPOINT [ "node ./build/index.js" ]
