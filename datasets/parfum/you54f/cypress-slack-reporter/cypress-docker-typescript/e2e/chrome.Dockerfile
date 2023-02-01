FROM debian:stretch-20181226
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
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \ 
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list | bash && \
  apt-get update && \
  apt-get install -y dbus-x11 google-chrome-stable \
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
          "Chrome version:  $(google-chrome --version) \n"
          
# FROM you54f/cypressbasechrome
# RUN npm i cypress
# RUN google-chrome --version
# RUN $(npm bin)/cypress run --browser chrome
