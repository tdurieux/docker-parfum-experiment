FROM node:10.21.0-alpine3.11 as react-build
ARG CI=true
WORKDIR /app
COPY . ./
RUN yarn && yarn cache clean;
RUN yarn test && yarn cache clean;
ARG CI=false
RUN yarn build && yarn cache clean;

FROM nginx:1.17
COPY --from=react-build /app/build /usr/share/nginx/html

