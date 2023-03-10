# Alpine with ruby support image
FROM redis:latest

# Copy redis-trib.rb
COPY redis-trib.rb /root/redis-trib.rb

# Copy redis.conf, port=7000, datadir=/data/
RUN mkdir -p /redis-conf
COPY redis.conf /redis-conf/redis.conf

# Update apt repo
RUN echo 'deb http://mirrors.aliyun.com/debian wheezy main contrib non-free \n\
deb-src http://mirrors.aliyun.com/debian wheezy main contrib non-free \n\
deb http://mirrors.aliyun.com/debian wheezy-updates main contrib non-free \n\
deb-src http://mirrors.aliyun.com/debian wheezy-updates main contrib non-free \n\
deb http://mirrors.aliyun.com/debian-security wheezy/updates main contrib non-free \n\
deb-src http://mirrors.aliyun.com/debian-security wheezy/updates main contrib non-free' > /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y rubygems && rm -rf /var/lib/apt/lists/*; # Install ruby and ruby-bundler


# Install gem redis plugin
RUN gem install --no-rdoc redis

# Run command below to build the image
# docker build docker-images-redis-ruby/ -t redis:ruby
# Run command below to run the container
# docker run -ti --rm redis:ruby /bin/bash
