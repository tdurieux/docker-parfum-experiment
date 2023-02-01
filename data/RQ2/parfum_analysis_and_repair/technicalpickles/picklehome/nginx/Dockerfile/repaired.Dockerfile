FROM nginx

RUN apt-get update && apt-get install -y --no-install-recommends openssl && rm -rf /var/lib/apt/lists/*;


ARG external_hostname
ARG internal_hostname

COPY nginx.conf /etc/nginx/nginx.conf

RUN sed -i -e "s/%%external_hostname%%/$external_hostname/" \
  -e "s/%%internal_hostname%%/$internal_hostname/" \
  /etc/nginx/nginx.conf
