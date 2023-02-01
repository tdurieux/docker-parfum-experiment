FROM openresty/openresty

RUN apt-get update && apt-get install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;

RUN rm /usr/bin/apt-get && rm /usr/bin/apt

RUN mkdir /tmp/cgi
COPY cgi /tmp/cgi
COPY nginx.conf /usr/local/openresty/nginx/conf
