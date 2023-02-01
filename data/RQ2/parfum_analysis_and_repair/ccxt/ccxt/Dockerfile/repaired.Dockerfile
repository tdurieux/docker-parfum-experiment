FROM ubuntu:20.04

# Supresses unwanted user interaction (like "Please select the geographic area" when installing tzdata)
ENV DEBIAN_FRONTEND=noninteractive

ADD ./ /ccxt
WORKDIR /ccxt

# Update packages (use us.archive.ubuntu.com instead of archive.ubuntu.com — solves the painfully slow apt-get update)
RUN sed -i 's/archive\.ubuntu\.com/us\.archive\.ubuntu\.com/' /etc/apt/sources.list

# Miscellaneous deps
RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg git ca-certificates && rm -rf /var/lib/apt/lists/*;
# PHP
RUN apt-get update && apt-get install -y --no-install-recommends php php-curl php-iconv php-mbstring php-bcmath php-gmp && rm -rf /var/lib/apt/lists/*;
# Node
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
# Python 3
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir 'idna==2.9' --force-reinstall
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN pip3 install --no-cache-dir tox
RUN pip3 install --no-cache-dir aiohttp
RUN pip3 install --no-cache-dir cryptography
RUN pip3 install --no-cache-dir requests
# Installs as a local Node & Python module, so that `require ('ccxt')` and `import ccxt` should work after that
RUN npm install && npm cache clean --force;
RUN ln -s /ccxt /usr/lib/node_modules/
RUN echo "export NODE_PATH=/usr/lib/node_modules" >> $HOME/.bashrc
RUN cd python \
    && python3 setup.py develop \
    && cd ..
## Install composer and everything else that it needs and manages
RUN /ccxt/composer-install.sh
RUN apt-get update && apt-get install -y --no-install-recommends zip unzip php-zip && rm -rf /var/lib/apt/lists/*;
RUN mv /ccxt/composer.phar /usr/local/bin/composer
RUN composer install
## Remove apt sources
RUN apt-get -y autoremove && apt-get clean && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

