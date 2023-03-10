FROM node:9.6.1 as builder

LABEL maintainer = "VMware <kreddyj@vmware.com>"
LABEL author = "Krishna Karthik <kreddyj@vmware.com>"

# set working directory
RUN mkdir /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# add `/usr/src/app/node_modules/.bin` to $PATH
ENV PATH /usr/src/app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package.json package-lock.json ./
RUN npm install && npm cache clean --force;
RUN npm install -g @angular/cli@6.2.1 && npm cache clean --force;

# add purser application to the working directory
COPY . .

# start purser application
RUN npm run build

# Build a small nginx image
FROM nginx:latest
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html