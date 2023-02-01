ARG BASE_IMAGE=uber/web-base-image:2.0.0
FROM $BASE_IMAGE

WORKDIR /fusion-plugin-apollo

COPY . .

RUN yarn && yarn cache clean;

RUN yarn --ignore-scripts run build-test && yarn cache clean;
