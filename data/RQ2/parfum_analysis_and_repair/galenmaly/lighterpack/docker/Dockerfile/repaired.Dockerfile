FROM ubuntu:16.04
MAINTAINER Nodar Nutsubidze <nodar.nutsubidze@gmail.com>
ENV HOSTNAME lighterpack

# Install packages
RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -qy \
  git \
  mongodb \
  nodejs \
  npm \
  python-pip && rm -rf /var/lib/apt/lists/*;

# Download git repo
RUN git clone https://github.com/galenmaly/lighterpack.git /var/www/lighterpack

# Move to the directory so we install the libraries in correct folder
RUN cd /var/www/lighterpack && npm install && npm cache clean --force;

# Web
EXPOSE 3000

WORKDIR /var/www/lighterpack
CMD ["nodejs", "app.js"]
