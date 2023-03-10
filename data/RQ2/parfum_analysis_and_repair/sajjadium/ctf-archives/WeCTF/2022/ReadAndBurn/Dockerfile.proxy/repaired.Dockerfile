FROM node:latest as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY ./ .
RUN npm run build

FROM nginx as production-stage
RUN mkdir /frontend
COPY --from=build-stage /app/dist /frontend
COPY nginx.conf /etc/nginx/nginx.conf
