FROM heroku/heroku:18

RUN apt-get update \
	&& apt-get install --no-install-recommends -y ruby-dev && rm -rf /var/lib/apt/lists/*;

COPY libvips-heroku18.tar.gz /usr/local/src

RUN cd /usr/local/lib \
    && tar xf /usr/local/src/libvips-heroku18.tar.gz \
    && ldconfig && rm /usr/local/src/libvips-heroku18.tar.gz

RUN gem install ruby-vips

RUN ruby -e 'require "vips"; puts "ruby-vips: libvips #{Vips::LIBRARY_VERSION}"'
