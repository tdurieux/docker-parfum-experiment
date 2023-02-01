FROM node:alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;
COPY . .
RUN npm run build

FROM nginx:alpine AS deploy
COPY --from=build /app/dist /usr/share/nginx/html