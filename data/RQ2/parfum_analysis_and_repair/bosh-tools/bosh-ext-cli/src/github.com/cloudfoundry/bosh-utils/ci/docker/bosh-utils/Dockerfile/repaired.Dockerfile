FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get -y upgrade; apt-get clean

RUN apt-get install --no-install-recommends -y build-essential zlib1g-dev libssl-dev libxml2-dev libsqlite3-dev libxslt1-dev libpq-dev libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git curl wget tar && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

# ...go
ADD install-go.sh /tmp/install-go.sh
RUN chmod a+x /tmp/install-go.sh
RUN cd tmp; ./install-go.sh; rm install-go.sh

# for hijack debugging
RUN apt-get install --no-install-recommends -y lsof psmisc strace && rm -rf /var/lib/apt/lists/*;
