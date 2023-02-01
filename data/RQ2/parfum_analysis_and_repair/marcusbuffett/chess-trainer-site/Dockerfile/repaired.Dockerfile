FROM node:16 AS base
WORKDIR /base
COPY package.json ./
COPY yarn.lock ./
RUN yarn install && yarn cache clean;
COPY . .
ENV NODE_ENV=production
# RUN npm set progress=false && \
#   npm install -g expo-cli
RUN yarn build
RUN yarn next export

FROM nginx:latest
# RUN rm -rf /etc/nginx
# COPY nginx /etc/nginx
COPY templates /etc/nginx/templates/
COPY --from=base /base/out /usr/share/nginx/html
