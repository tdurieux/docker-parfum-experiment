FROM ubuntu:latest

ENTRYPOINT /bin/bash

# Set the locale
RUN apt-get update && apt-get install -y --no-install-recommends locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Install dependencies
RUN apt-get update && apt-get install -y git curl autoconf bison build-essential libssl1.0-dev \
    libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm5 libgdbm-dev
RUN apt-get -y autoclean

# Install rbenv
RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv
RUN cd /root/.rbenv && src/configure && make -C src

ENV PATH /root/.rbenv/bin:$PATH
ENV PATH /root/.rbenv/shims:$PATH

RUN echo 'eval "$(rbenv init -)"' >> /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .bashrc

# Install ruby-build
RUN mkdir -p "$(rbenv root)"/plugins
RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build


# Install ruby
ENV RUBY_CONFIGURE_OPTS --disable-install-doc
ENV RUBY_VERSIONS "2.3.8 2.4.5 2.5.5 2.6.3"
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN for version in ${RUBY_VERSIONS}; do \
        rbenv install "$version" && rbenv global "$version" && \
        gem install bundler:1.17.3 && gem update --system \
    ; done

RUN apt-get -y autoremove && apt-get -y autoclean
