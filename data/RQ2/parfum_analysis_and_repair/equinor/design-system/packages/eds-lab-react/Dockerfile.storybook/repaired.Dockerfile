FROM nginx:1.15.8-alpine

WORKDIR /app

COPY ./packages/eds-lab-react/storybook-build ./
COPY ./packages/eds-lab-react/nginx.conf /etc/nginx/conf.d/default.conf