# BUILD
FROM node:lts-alpine as build
WORKDIR /srv/app
ENV PATH /srv/app/node_modules/.bin:$PATH
COPY ./frontend/package.json ./
COPY ./frontend/package-lock.json ./
RUN npm ci --silent
RUN npm install react-scripts@3.4.1 -g --silent && npm cache clean --force;
COPY ./frontend ./
RUN npm run build

# FINAL
FROM nginx:stable-alpine
RUN mkdir /srv/http
## add permissions
RUN chown -R nginx:nginx /srv/http && chmod -R 754 /srv/http
COPY --from=build /srv/app/build /srv/http
# Allow custom nginx config for React Router etc
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]