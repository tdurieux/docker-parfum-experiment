FROM centos:7

RUN yum -y install openssl-devel readline-devel ncurses ncurses-devel && rm -rf /var/cache/yum
RUN yum -y groupinstall "Development Tools"
RUN yum -y install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm && rm -rf /var/cache/yum
RUN yum -y install postgresql96-libs postgresql96-devel && rm -rf /var/cache/yum
RUN ln -s /usr/pgsql-9.6/bin/pg_config /usr/local/bin/

RUN mkdir ruby
RUN curl -f -L https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.1.tar.gz | tar xz --strip=1 -C ruby
RUN cd ruby && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
RUN rm -R ruby

WORKDIR /backend

RUN gem install bundler
ADD Gemfile /backend/Gemfile
ADD Gemfile.lock /backend/Gemfile.lock
RUN bundle install

ADD . /backend

EXPOSE 3000
