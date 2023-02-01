FROM node:12.6.0-alpine as builder
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow
RUN apk update && apk upgrade && \
  apk add --no-cache bash git openssh

RUN npm config set registry http://registry.npmjs.org/
RUN npm config set strict-ssl false
ARG env=rfi-prod
WORKDIR /scicat_frontend
COPY package.json  /scicat_frontend
RUN npm install
COPY . /scicat_frontend/
# Site image needs to be copied to assets before building
COPY CI/RFI/site.png /scicat_frontend/src/assets/images/site.png
RUN npx ng build --configuration=${env}

FROM nginx:alpine
RUN sed -i -e 's/^root::/root:!:/' /etc/shadow
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /scicat_frontend/dist/ /usr/share/nginx/html
COPY scripts/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
