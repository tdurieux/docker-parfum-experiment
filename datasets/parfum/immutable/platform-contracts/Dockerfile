FROM {{DOCKER_IMAGE_DEV}}

COPY . .
RUN lerna bootstrap
RUN yarn build:all
