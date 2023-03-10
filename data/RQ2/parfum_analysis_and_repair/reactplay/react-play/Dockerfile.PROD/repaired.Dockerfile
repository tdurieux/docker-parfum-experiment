FROM buildkite/puppeteer as build

WORKDIR /app/code
COPY .  /app/code

RUN npm install && npm cache clean --force;
RUN npm run build

FROM nginx:stable-alpine
COPY --from=build /app/code/build /usr/share/nginx/html
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]