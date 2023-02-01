FROM ruby:2.6.5

# docker build -f docker/Dockerfile -t qpixel_uwsgi .

ENV RUBYOPT="-KU -E utf-8:utf-8"
RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc && \
    apt-get install --no-install-recommends -y make && \
    apt-get install --no-install-recommends -y \
        default-libmysqlclient-dev \
        autoconf \
        bison \
        build-essential \
        libssl-dev \
        libyaml-dev \
        libreadline-dev \
        zlib1g-dev \
        libncurses5-dev \
        libffi-dev \
        libgdbm-dev && \
   apt-get install --no-install-recommends -y default-mysql-server && rm -rf /var/lib/apt/lists/*;

# Install nodejs and imagemagick
WORKDIR /opt
RUN wget https://nodejs.org/dist/v12.18.3/node-v12.18.3-linux-x64.tar.xz && \
    tar xf node-v12.18.3-linux-x64.tar.xz && \
    wget https://imagemagick.org/download/binaries/magick && \
    chmod +x magick && \
    mv magick /usr/local/bin/magick && rm node-v12.18.3-linux-x64.tar.xz

ENV NODEJS_HOME=/opt/node-v12.18.3-linux-x64/bin
ENV PATH=$NODEJS_HOME:$PATH

# Add core code to container
WORKDIR /code
COPY . /code
RUN gem install bundler && \
    bundle install

EXPOSE 80 443 3000
ENTRYPOINT ["/bin/bash"]
CMD ["/code/docker/entrypoint.sh"]

