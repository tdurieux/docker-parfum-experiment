FROM lavoweb/php-7.3:composer

# Add MySQLi
RUN docker-php-ext-install mysqli

# Add Chromium browser to enable pdf creation
RUN apt-get --allow-releaseinfo-change update && apt install -y --no-install-recommends \
    chromium \
    git && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/cache/apk/* \
    rm -rf /tmp/*

# Add default theme
RUN mkdir -p themes/margot \
    && curl -f -o - -sSL https://github.com/YesWiki/yeswiki-theme-margot/archive/master.tar.gz \
        | tar xzfv - --strip-components 1 -C themes/margot

# Composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Node & NPM & Yarn
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://npmjs.org/install.sh | sh
RUN npm install -g yarn && npm cache clean --force;

# Allow container to write wakka.config.php
RUN chmod +wx .