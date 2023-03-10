# FROM node:12.16.3-alpine3.9

# WORKDIR /app
# COPY package.json ./
# #RUN npm install --only=prod --silent
# RUN npm install --silent
# COPY ./ ./
# CMD ["npm", "run", "start"]



FROM node:lts-alpine3.12 as builder

RUN mkdir -p /project
WORKDIR '/project'

COPY ./package*.json ./
RUN npm install && npm cache clean --force;

COPY . ./

RUN npm run build

FROM nginx

# RUN apt update && apt upgrade && \
#  apt install -y bash vim less curl iputils-ping dnsutils

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /project/build /usr/share/nginx/html