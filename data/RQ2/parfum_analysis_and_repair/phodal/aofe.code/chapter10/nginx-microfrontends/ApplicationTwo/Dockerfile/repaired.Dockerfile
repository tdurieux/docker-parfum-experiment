# STEP 1 build static website
FROM node:alpine as builder
RUN apk update && apk add --no-cache make git
# Create app directory
WORKDIR /app
# Install app dependencies
#COPY package.json package-lock.json Makefile  /app/
COPY package.json /app/
RUN cd /app && npm set progress=false && npm install && npm cache clean --force;
# Copy project files into the docker image
COPY .  /app
RUN cd /app && npm run build

# STEP 2 build a small nginx image with static website
FROM nginx:alpine
## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*
## From 'builder' copy website to default nginx public folder
COPY --from=builder /app/dist/ApplicationTwo /usr/share/nginx/html
COPY ./nginx-default-cfg/default.conf /etc/nginx/conf.d/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
