#################################
# STEP 1: NPM install
#################################
FROM node:14-alpine as initial-stage

RUN apk add --no-cache nodejs nodejs-npm bash chromium nss chromium-chromedriver

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_DRIVER=/usr/bin/chromedrive

RUN npm install -g @angular/cli && npm cache clean --force;

WORKDIR /app

COPY package*.json ./

RUN npm install && npm cache clean --force;

#################################
# STEP 2: Build
#################################
FROM initial-stage AS build-stage

RUN apk --no-cache add nginx

WORKDIR /app

COPY image-files/ /

COPY . .

EXPOSE 80

#################################
# STEP 3: Deployment
#################################
FROM build-stage AS build-production-stage

WORKDIR /app

RUN npm run build

FROM nginx:stable-alpine AS production-stage

COPY image-files/ /

COPY --from=build-production-stage /app/dist /srv

EXPOSE 80

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD ["nginx", "-g", "daemon off;"]
