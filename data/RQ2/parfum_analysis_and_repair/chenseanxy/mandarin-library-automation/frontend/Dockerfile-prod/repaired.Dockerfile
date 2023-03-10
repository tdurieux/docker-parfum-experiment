# Building & Testing stage
FROM node:12.16.1-alpine as build-stage

ARG npmrepo=https://registry.npm.taobao.org

WORKDIR /app

# Installing dependencies early to leverage caching
COPY package*.json ./

RUN npm install --registry=${npmrepo} && npm cache clean --force;

# Copying project files
COPY . .

RUN npm run build

# Production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html

ENTRYPOINT ["nginx", "-g", "daemon off;"]
