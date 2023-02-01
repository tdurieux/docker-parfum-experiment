FROM phpdockerio/php72-fpm:latest
WORKDIR "/application"

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install  php7.2-mysql php7.2-sqlite3 \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install git
RUN apt-get update \
    && apt-get -y --no-install-recommends install git \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install NodeJS
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Cypress dependencies
RUN apt-get -y --no-install-recommends install libgtk2.0-0 libgtk-3-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb && rm -rf /var/lib/apt/lists/*;
