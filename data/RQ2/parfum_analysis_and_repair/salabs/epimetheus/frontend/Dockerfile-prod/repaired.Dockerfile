# Inspirational references
# https://medium.com/swlh/dockerizing-a-react-application-with-docker-and-nginx-19e88ef8e99a
# https://medium.com/thepeaklab/how-to-deploy-a-react-application-to-production-with-docker-multi-stage-builds-4da347f2d681

FROM node:alpine as build

# build application
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json
RUN npm install --silent && npm cache clean --force;
RUN npm install react-scripts -g --silent && npm cache clean --force;
COPY . /usr/src/app
RUN npm run build

# set up production environment
FROM nginx:alpine

ARG nginx_port=8080
ARG backend_url=http://backend-server:5000

ENV NGINX_PORT $nginx_port
ENV BACKEND_URL $backend_url

EXPOSE $NGINX_PORT

COPY --from=build /usr/src/app/build /usr/share/nginx/html

RUN rm /etc/nginx/conf.d/default.conf && \
    rm /etc/nginx/nginx.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

RUN sed -i -e 's/$NGINX_PORT/'"$NGINX_PORT"'/g' /etc/nginx/conf.d/default.conf
# Using '#' as a delimeter here because url contains slashes and it confuses sed
RUN sed -i -e 's#$BACKEND_URL#'"$BACKEND_URL"'#g#' /etc/nginx/conf.d/default.conf


RUN chown -R nginx:nginx /usr/share/nginx/html && chmod -R 755 /usr/share/nginx/html && \
        chown -R nginx:nginx /etc/nginx/conf.d


USER nginx


CMD ["nginx", "-g", "daemon off;"]
