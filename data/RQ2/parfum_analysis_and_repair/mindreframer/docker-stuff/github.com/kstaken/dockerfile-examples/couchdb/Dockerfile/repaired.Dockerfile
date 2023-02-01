# Basic install of couchdb
#
# This will move the couchdb http server to port 8101 so adjust the port for your needs.
#
# Currently installs couchdb 1.3.1

FROM ubuntu
MAINTAINER Kimbro Staken

RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y erlang-dev erlang-manpages erlang-base-hipe erlang-eunit erlang-nox erlang-xmerl erlang-inets && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libmozjs185-dev libicu-dev libcurl4-gnutls-dev libtool wget && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp ; wget https://www.bizdirusa.com/mirrors/apache/couchdb/source/1.3.1/apache-couchdb-1.3.1.tar.gz

RUN cd /tmp && tar xvzf apache-couchdb-1.3.1.tar.gz && rm apache-couchdb-1.3.1.tar.gz
RUN apt-get install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN cd /tmp/apache-couchdb-* ; ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install

RUN printf "[httpd]\nport = 8101\nbind_address = 0.0.0.0" > /usr/local/etc/couchdb/local.d/docker.ini

EXPOSE 8101

CMD ["/usr/local/bin/couchdb"]


