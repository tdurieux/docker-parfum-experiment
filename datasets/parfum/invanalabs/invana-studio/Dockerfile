# Multi stage docker build

## stage1: build react
FROM node:12 as react-build
WORKDIR /code
COPY . ./

RUN npm set progress=false && \
    npm config set depth 0 && \
    npm install && \
    npm cache clean --force
# just to make sure only clean code goes to build
RUN ./node_modules/.bin/eslint src/**/*.js
RUN npm run-script build --production

# stage2: deploy to nginx
FROM nginx:alpine as production
COPY --from=react-build /code/dockerfiles/nginx.conf /etc/nginx/conf.d/default.conf.template
COPY --from=react-build /code/build /usr/share/nginx/html
ENV PORT=${PORT:-8300}
EXPOSE $PORT
CMD envsubst '$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
