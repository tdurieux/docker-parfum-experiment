FROM node:latest

RUN apt-get update; apt-get -y upgrade; apt-get clean

RUN apt-get install --no-install-recommends -y git curl wget tar make; rm -rf /var/lib/apt/lists/*; apt-get clean

RUN apt-get install --no-install-recommends -y sqlite3 libsqlite3-dev; rm -rf /var/lib/apt/lists/*; apt-get clean

RUN apt-get install --no-install-recommends -y mysql-client libmysqlclient-dev; rm -rf /var/lib/apt/lists/*; apt-get clean

RUN apt-get install --no-install-recommends -y jq; rm -rf /var/lib/apt/lists/*; apt-get clean

RUN apt-get install --no-install-recommends -y postgresql-9.3 postgresql-client-9.3 libpq-dev; rm -rf /var/lib/apt/lists/*; apt-get clean

RUN apt-get install --no-install-recommends -y sudo; rm -rf /var/lib/apt/lists/*; apt-get clean

# azure command line
RUN npm install -g azure-cli && npm cache clean --force;

# chruby
RUN mkdir /tmp/chruby && \
    cd /tmp && \
    curl -f https://codeload.github.com/postmodern/chruby/tar.gz/v0.3.9 | tar -xz && \
    cd /tmp/chruby-0.3.9 && \
    sudo ./scripts/setup.sh && \
    rm -rf /tmp/chruby

# ruby-install
RUN mkdir /tmp/ruby-install && \
    cd /tmp && \
    curl -f https://codeload.github.com/postmodern/ruby-install/tar.gz/v0.5.0 | tar -xz && \
    cd /tmp/ruby-install-0.5.0 && \
    sudo make install && \
    rm -rf /tmp/ruby-install

# ruby
RUN ruby-install ruby 2.2.4

# Bundler and BOSH CLI
RUN /bin/bash -l -c "source /etc/profile.d/chruby.sh ;  \
                     chruby 2.2.4 ;                     \
                     gem install bundler bosh_cli --no-ri --no-rdoc"

