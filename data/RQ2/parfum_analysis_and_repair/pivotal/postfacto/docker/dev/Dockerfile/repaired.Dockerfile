FROM ubuntu:20.04
MAINTAINER pivotal

SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y autoconf bison build-essential curl git libfontconfig libpq-dev libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev libnss3 libxi6 libgconf-2-4 unzip wget && rm -rf /var/lib/apt/lists/*;

# Install Rbenv and Ruby

RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv && echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
ENV PATH $PATH:/root/.rbenv/bin:/root/.rbenv/shims
RUN cd /root/.rbenv/plugins/ruby-build && git pull && cd -
ENV RUBY_VERSION 2.7.3
RUN rbenv install $RUBY_VERSION && rbenv global $RUBY_VERSION && rbenv rehash
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN gem install bundler:2.2.16

# Install Node
ENV NVM_DIR /usr/local/nvm
RUN mkdir -p $NVM_DIR
ENV NODE_VERSION 14.16.1
RUN curl -f --silent -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install Python for Node SASS
RUN apt-get update && apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;


# Install Chrome WebDriver
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN CHROMEDRIVER_VERSION=$( curl -f https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -f -sS -o /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# Install Google Chrome
RUN curl -f -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get -yqq update && apt-get -yqq --no-install-recommends install google-chrome-stable && rm -rf /var/lib/apt/lists/*

# Install Sqlite dev tools
RUN apt-get update && apt-get install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

# Install zip for packaging
RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

# Install tmux for run/test scripts
RUN apt-get update && apt-get install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;

# Cache dependencies
COPY . /postfacto
RUN cd /postfacto && ./deps.sh && cd .. && rm -rf /postfacto
