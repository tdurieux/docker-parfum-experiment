FROM nginx:latest
RUN apt-get update && apt-get -y --no-install-recommends install nano && rm -rf /var/lib/apt/lists/*;
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.backup

ADD conf.d/ /etc/nginx/conf.d/