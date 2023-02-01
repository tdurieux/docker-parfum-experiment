FROM node:lts-buster-slim
RUN apt-get update && apt-get -y --no-install-recommends install yarnpkg && rm -rf /var/lib/apt/lists/*;
RUN yarn global add @angular/cli
RUN ng config -g cli.packageManager yarn
RUN mkdir -p /pinbox
WORKDIR /pinbox
COPY . /pinbox/
RUN yarn
RUN ng build --prod

FROM nginx:stable
RUN rm -rf /usr/share/nginx/html/*
COPY nginx.conf /etc/nginx/nginx.conf
COPY server.conf /etc/nginx/conf.d/default.conf
COPY --from=0 /pinbox/dist/pinbox/ /usr/share/nginx/html/
CMD ["nginx", "-g", "daemon off;"]