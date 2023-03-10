#
# ---- Build ----
FROM node:dubnium-alpine as base
WORKDIR /root/build

# install and cache node packages
COPY package.json yarn.lock ./
RUN yarn install && yarn cache clean;
COPY . .
RUN yarn build && yarn cache clean;

#
# ---- Release ----
FROM nginx:alpine
# copy production node_modules
COPY --from=base /root/build/build /var/www
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
