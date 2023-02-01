FROM nginx
RUN apt-get -y update && apt-get install --no-install-recommends -y curl nano && rm -rf /var/lib/apt/lists/*;
COPY sample_app_nginx.conf /etc/nginx/nginx.conf
