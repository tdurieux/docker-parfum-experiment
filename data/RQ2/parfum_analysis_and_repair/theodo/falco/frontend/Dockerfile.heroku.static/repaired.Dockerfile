# First stage: collect static files in base image
FROM node:12.14 AS node


WORKDIR /code

COPY . /code/
RUN yarn && yarn cache clean;
RUN yarn build && yarn cache clean;


# Second stage: static files server
FROM nginx:1.15

# Custom config
RUN rm /etc/nginx/conf.d/default.conf
COPY .nginx.conf /etc/nginx/conf.d/falco.conf

COPY /code/static /static
