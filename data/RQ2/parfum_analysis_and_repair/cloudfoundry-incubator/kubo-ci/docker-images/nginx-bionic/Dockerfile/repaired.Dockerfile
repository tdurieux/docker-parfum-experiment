# Dockerfile for Ubuntu 18.04 nginx

# Pull base image.
FROM ubuntu:18.04

# Maintainer
MAINTAINER CFCR <cfcr@pivotal.io>

# Install Packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
  DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
  curl \
  nginx && rm -rf /var/lib/apt/lists/*;

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY ./nginx.conf /etc/nginx/sites-enabled/default

EXPOSE 443 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
