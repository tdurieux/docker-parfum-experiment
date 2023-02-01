FROM node:lts-alpine3.12 as builder

RUN mkdir -p /project
WORKDIR '/project'

COPY ./package*.json ./
RUN npm install && npm cache clean --force;

COPY . ./

RUN npm run build

FROM nginx

RUN apt update && apt upgrade && \
  apt install --no-install-recommends -y bash vim less curl iputils-ping dnsutils && rm -rf /var/lib/apt/lists/*;

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /project/build /usr/share/nginx/html