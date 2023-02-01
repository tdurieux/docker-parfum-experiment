FROM ubuntu:14.04
MAINTAINER Yoshikawa Ryota <yoshikawa@rrreeeyyy.com>

RUN apt-get -y update && apt-get -y --no-install-recommends install \
      gcc \
      git \
      make \
      ruby \
      perl \
      bison \
      libnl-dev \
      && gem install mgem --no-rdoc --no-ri && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/mruby/mruby.git /usr/local/mruby
WORKDIR /usr/local/mruby

RUN mgem add \
        mruby-ipvs \
        # add some gems if you want
      && mgem config default > build_config.rb

RUN ruby ./minirake

CMD ["/usr/local/mruby/build/host/bin/mruby"]
