FROM node:11

RUN mkdir /app
WORKDIR /app
COPY . .

RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;
RUN npm run build



COPY deploy/nginx-default /etc/nginx/sites-enabled/default

EXPOSE 3000
CMD sh ./deploy/commands.sh