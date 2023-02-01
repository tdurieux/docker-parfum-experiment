FROM node:14-alpine as build
WORKDIR /app
COPY package.json ./
COPY yarn.lock ./
RUN wget https://raw.githubusercontent.com/GameTactic/Deployment/master/room/.env && yarn install && yarn cache clean;
COPY . .
RUN yarn build && yarn cache clean;

FROM nginx:stable-alpine as production
COPY --from=build /app/dist /app
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
