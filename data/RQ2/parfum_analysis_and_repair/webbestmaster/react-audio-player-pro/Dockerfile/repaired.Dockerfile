FROM node:14.4.0-stretch
WORKDIR /usr/app/
COPY ./ ./

RUN rm -rf ./node_modules
RUN npm install && npm run build && npm cache clean --force;

RUN apt-get update && apt-get install -y --no-install-recommends nginx && rm -rf /var/lib/apt/lists/*;

CMD ["nginx", "-c", "/usr/app/nginx/nginx.docker.conf", "-g", "daemon off;"]
