FROM node:8.11.4-alpine as builder
WORKDIR /{{project_name}}
COPY . ./
RUN yarn install && yarn cache clean;
RUN yarn build

FROM node:8.11.4-alpine
WORKDIR /{{project_name}}
COPY --from=builder /{{project_name}} ./
RUN yarn install --production=true && yarn cache clean;
EXPOSE 8080
ENTRYPOINT ["yarn"]
