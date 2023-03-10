FROM ubuntu:14.04.3
ENV DEBIAN_FRONTEND noninteractive

ENV RUBY_VERSION 2.2

# generate locales
ENV LANG en_US.UTF-8
RUN locale-gen $LANG

EXPOSE 9292

# system packages
RUN apt-get install --no-install-recommends -y software-properties-common && \
    apt-add-repository ppa:brightbox/ruby-ng && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y ruby$RUBY_VERSION && \
    apt-get install --no-install-recommends -y ruby$RUBY_VERSION-dev && \
    apt-get install --no-install-recommends -y build-essential && \
    apt-get install --no-install-recommends -y libssl-dev && \
    apt-get install --no-install-recommends -y libldap2-dev && \
    apt-get install --no-install-recommends -y libsasl2-dev && rm -rf /var/lib/apt/lists/*;

# board example
RUN ruby -r whimsy/asf -e "ASF::LDAP.configure"
ADD . /home/board
WORKDIR /home/board
CMD ["/usr/bin/ruby", "board.rb", "--port=9292"]
