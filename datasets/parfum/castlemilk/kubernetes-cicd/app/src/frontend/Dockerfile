FROM node:10.12.0 as build-deps

WORKDIR /usr/src/app
COPY package.json yarn.lock ./

# stage 1 - install packages 
RUN yarn

# stage 2 - build app
COPY . ./ 
RUN yarn build

# stage 3 - copy build artifacts to slim nginx server
FROM nginx:1.12-alpine
COPY --from=build-deps /usr/src/app/build /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
COPY ./env.sh .
COPY .env .
RUN apk add --no-cache bash
RUN chmod +x env.sh
EXPOSE 80
CMD ["/bin/bash", "-c", "/usr/share/nginx/html/env.sh && nginx -g \"daemon off;\""]
