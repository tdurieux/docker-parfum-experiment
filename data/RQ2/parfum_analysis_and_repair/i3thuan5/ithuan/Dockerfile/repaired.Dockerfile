FROM debian:latest
MAINTAINER g0v Contributors

ENV DEBIAN_FRONTEND noninteractive
WORKDIR /app
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install --no-install-recommends -y nginx && \
  apt-get clean && rm -rf /var/lib/apt/list && rm -rf /var/lib/apt/lists/*;

COPY _public/ /app
RUN sed -i 's/^\troot \/.*/\troot \/app;/' /etc/nginx/sites-enabled/default
CMD nginx && tail -f /var/log/nginx/error.log
