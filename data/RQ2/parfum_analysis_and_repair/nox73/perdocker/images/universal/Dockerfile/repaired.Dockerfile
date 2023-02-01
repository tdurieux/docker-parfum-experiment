# Perdocker
#
# VERSION               0.0.1

FROM      ubuntu
MAINTAINER Nox73

# make sure the package repository is up to date
RUN apt-get update
RUN apt-get install --no-install-recommends -y wget ca-certificates build-essential && rm -rf /var/lib/apt/lists/*;

# RUBY
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://get.rvm.io | bash -s stable --ruby

# C & C++
RUN apt-get install --no-install-recommends -y gcc g++ && rm -rf /var/lib/apt/lists/*;

# GO
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /usr/local/go/

RUN wget --no-verbose https://go.googlecode.com/files/go1.2.src.tar.gz
RUN tar -v -C /usr/local -xzf go1.2.src.tar.gz && rm go1.2.src.tar.gz
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1

# NODEJS
RUN apt-get install --no-install-recommends -y lamp-server^ && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://nodejs.org/dist/v0.10.24/node-v0.10.24-linux-x64.tar.gz > node-v0.10.24-linux-x64.tar.gz
RUN tar -xvzf node-v0.10.24-linux-x64.tar.gz && rm node-v0.10.24-linux-x64.tar.gz
RUN mv node-v0.10.24-linux-x64 /usr/local/node
RUN ln -s /usr/local/node/bin/node /usr/bin/node

#PHP
RUN apt-get install --no-install-recommends -y php5 && rm -rf /var/lib/apt/lists/*;

#PYTHON
# built-in to ububntu

# USER
RUN groupadd perdocker
RUN useradd -g perdocker perdocker

USER perdocker
