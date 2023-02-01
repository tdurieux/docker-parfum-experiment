FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get -y upgrade && apt-get clean

RUN apt-get install --no-install-recommends -y build-essential zlib1g-dev libssl-dev libxml2-dev libsqlite3-dev libxslt1-dev libpq-dev libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git curl wget tar && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

# ...ruby
ADD install-ruby.sh /tmp/install-ruby.sh
RUN chmod a+x /tmp/install-ruby.sh
RUN cd tmp && ./install-ruby.sh && rm install-ruby.sh

# package manager provides 1.4.3, which is too old for vagrant-aws
RUN cd /tmp && wget -q https://releases.hashicorp.com/vagrant/1.8.6/vagrant_1.8.6_x86_64.deb \
 && echo "e6d83b6b43ad16475cb5cfcabe7dc798002147c1d048a7b6178032084c7070da  vagrant_1.8.6_x86_64.deb" | sha256sum -c - \
 && dpkg -i vagrant_1.8.6_x86_64.deb
RUN vagrant plugin install vagrant-aws

# bosh-init dependencies
RUN apt-get install --no-install-recommends -y mercurial && apt-get clean && rm -rf /var/lib/apt/lists/*;
# ...go
ADD install-go.sh deps-golang /tmp/
RUN chmod a+x /tmp/install-go.sh
RUN cd /tmp && ./install-go.sh && rm install-go.sh deps-golang

# lifecycle ssh test
RUN apt-get install --no-install-recommends -y sshpass && apt-get clean && rm -rf /var/lib/apt/lists/*;

# integration registry tests
RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;

# for hijack debugging
RUN apt-get install --no-install-recommends -y lsof psmisc strace && rm -rf /var/lib/apt/lists/*;
