FROM node:stretch as builder

RUN apt-get update && apt-get install --no-install-recommends -y yarn && rm -rf /var/lib/apt/lists/*;
COPY . /exams
WORKDIR /exams
RUN yarn install && yarn cache clean;
RUN yarn build

FROM nginx

COPY --from=builder /exams/build /usr/share/nginx/html
