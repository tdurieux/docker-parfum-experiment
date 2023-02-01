FROM debian:stretch-20181226
ARG FIREFOX_VERSION=57.0.2
ENV NVM_VERSION=0.34.0
ENV NODE_VERSION=8.15.0
ENV NVM_DIR /usr/local/nvm
RUN mkdir $NVM_DIR \
&& apt-get update \
  && apt-get install -y curl \
    libgtk2.0-0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    libxtst6 \
    xvfb \
    zip \
    gnupg \
    wget \
  && curl -o- https://raw.githubusercontent.com/creationix/nvm/v$NVM_VERSION/install.sh | bash \
  && echo "source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default" | bash \
  && wget --no-verbose -O /tmp/firefox.tar.bz2 https://download-installer.cdn.mozilla.net/pub/firefox/releases/$FIREFOX_VERSION/linux-x86_64/en-US/firefox-$FIREFOX_VERSION.tar.bz2 \
  && tar -C /opt -xjf /tmp/firefox.tar.bz2 \
  && rm /tmp/firefox.tar.bz2 \
  && ln -fs /opt/firefox/firefox /usr/bin/firefox \
  && apt-get purge -y curl \
  && apt-get -y --purge autoremove \
  && rm -rf /var/lib/apt/lists/* /etc/apt/sources.list.d/*
ENV NODE_PATH $NVM_DIR/$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
ENV TERM xterm
ENV npm_config_loglevel warn
ENV npm_config_unsafe_perm true
RUN echo  "installing yarn:    $(npm i -g yarn) \n" \
          "node version:    $(node -v) \n" \
          "npm version:     $(npm -v) \n" \
          "yarn verison:    $(yarn -v) \n" \
          "debian version:  $(cat /etc/debian_version) \n" \
          "Firefox version:  $(firefox --version) \n"
          
# FROM you54f/cypressbasefirefox
# RUN npm i cypress
# RUN firefox --version
# RUN $(npm bin)/cypress run --browser firefox