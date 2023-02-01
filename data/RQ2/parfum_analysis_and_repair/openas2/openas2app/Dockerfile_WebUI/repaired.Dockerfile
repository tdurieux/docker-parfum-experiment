FROM node:lts-alpine AS web-builder
RUN npm install -g --force yarn && npm cache clean --force;
COPY ./WebUI /usr/src/webui
WORKDIR /usr/src/webui
RUN yarn install && yarn cache clean;
RUN npx browserslist@latest --update-db
RUN yarn run build && yarn cache clean;

FROM nginx
COPY --from=web-builder /usr/src/webui/dist /usr/share/nginx/html
