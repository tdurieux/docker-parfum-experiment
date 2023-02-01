FROM node:12-alpine
COPY . .
RUN npm i && npm cache clean --force;
RUN npx lerna bootstrap
RUN npm run build
