FROM nginx
ENV APPLICATION_NAME=abacuza
RUN apt update && apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Dockerize the parameters from env variables
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY nginx.conf.tmpl /etc/nginx/nginx.conf.tmpl
CMD dockerize -template /etc/nginx/nginx.conf.tmpl:/etc/nginx/nginx.conf nginx -g "daemon off;"
