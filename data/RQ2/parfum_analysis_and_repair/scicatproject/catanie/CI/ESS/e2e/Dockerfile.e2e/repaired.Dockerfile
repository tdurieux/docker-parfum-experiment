FROM node:16-alpine as builder
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow
RUN apk update && apk upgrade && \
  apk add --no-cache bash git openssh wget

WORKDIR /frontend
COPY package*.json  /frontend/
RUN npm ci
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
COPY . /frontend/
RUN npx ng build

FROM nginx:1.21-alpine
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow
RUN apk update && apk upgrade && \
  apk add --no-cache bash
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /frontend/dist/ /usr/share/nginx/html
COPY --from=builder /frontend/wait-for-it.sh /
RUN chmod +x /wait-for-it.sh
COPY scripts/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80