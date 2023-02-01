FROM node:12.22.7
ADD package.json .
RUN npm install && npm cache clean --force;
RUN npm install express && npm cache clean --force;
ADD src src
ADD tsconfig.json tsconfig.json
RUN npm run build