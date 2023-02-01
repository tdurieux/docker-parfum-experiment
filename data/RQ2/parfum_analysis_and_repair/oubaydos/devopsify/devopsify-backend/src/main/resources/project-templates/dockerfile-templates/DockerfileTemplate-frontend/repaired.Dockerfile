# build phase

# base image should be node
FROM node:node-version as build
# creating and moving to the working directory
WORKDIR /workdir
# add node_modules bin to path
ENV PATH /workdir/node_modules/.bin:$PATH
# copying package jsons
COPY package.json ./
COPY package-lock.json ./
# clean installing dependencies
RUN npm ci --silent
# there could be a problem in the build phase regarding "MiniCssExtractPlugin is not a constructor"
# in that case uncomment this line
# RUN npm i -D --save-exact mini-css-extract-plugin@mini-css-extract-plugin-version
# moving project files
COPY . .
# build
RUN npm run build


# production

FROM nginx:nginx-version-nginx-base-os
COPY --from=build /workdir/build /usr/share/nginx/html
# to export front end routes / error pages .. to nginx
# nginx/nginx.conf must be set
# TODO if none found we will provide one
#COPY nginx-configuration-file-location /etc/nginx/conf.d/default.conf