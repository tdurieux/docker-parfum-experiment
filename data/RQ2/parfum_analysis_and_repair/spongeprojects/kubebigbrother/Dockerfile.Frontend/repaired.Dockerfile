FROM node:16.2 as node

COPY . /working

WORKDIR /working

RUN npm i -g npm && npm cache clean --force;

RUN npm i && npm cache clean --force;

RUN npm run build

FROM nginx:1.19.5

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=node /working/dist /usr/share/nginx/html
