FROM public.ecr.aws/bitnami/node:16.5.0 AS build
WORKDIR /usr/src/app
COPY package.json ./
RUN yarn && yarn cache clean;
COPY . .
RUN yarn build:prod && yarn cache clean;

FROM public.ecr.aws/nginx/nginx:1.21
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /usr/src/app/dist /usr/share/nginx/html/app
