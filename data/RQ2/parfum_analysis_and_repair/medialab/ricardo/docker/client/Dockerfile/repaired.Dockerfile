FROM nginx:latest

ADD ./nginx.conf /etc/nginx/nginx.prod.conf
ADD ./nginx.dev.conf /etc/nginx/nginx.dev.conf
ADD ./docker-entrypoint.sh /docker-entrypoint.sh

RUN ["chmod", "+x", "/docker-entrypoint.sh"]
RUN apt-get update && apt-get -y --no-install-recommends install npm curl && rm -rf /var/lib/apt/lists/*;
RUN npm install -g n && npm cache clean --force;
RUN n lts
RUN npm i npm@latest -g && npm cache clean --force;

EXPOSE 80

ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh", "$MODE"]
