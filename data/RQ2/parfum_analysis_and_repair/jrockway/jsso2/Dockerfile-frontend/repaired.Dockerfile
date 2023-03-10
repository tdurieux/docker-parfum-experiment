FROM node:fermium AS build
WORKDIR /jsso2

COPY package.json package-lock.json /jsso2/
RUN npm ci

COPY . /jsso2/
RUN npm run build

FROM nginx:latest
WORKDIR /
COPY --from=build /jsso2/public/ /usr/share/nginx/html/