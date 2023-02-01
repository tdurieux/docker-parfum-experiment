FROM php:7.0-apache

# Install Node
RUN NODE_VERSION=$( curl -f https://semver.io/node/stable) \
    && NPM_VERSION=$( curl -f https://semver.io/npm/stable) \
    && curl -f -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.gz" \
    && npm install -g npm@"$NPM_VERSION" \
    && npm cache clear --force

# Install Git
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends --fix-missing -y git && rm -rf /var/lib/apt/lists/*;

# Copy source	
RUN mkdir -p /tmp
WORKDIR /tmp	
COPY . ./	

# Install dependencies	
RUN npm install -g gulp && npm install --save-dev jshint gulp-jshint && npm install && npm cache clean --force;

# Build and move main application
RUN gulp clean --silent && gulp init && \
	mv build/* /var/www/html/ && \
	mv /var/www/html/root.htaccess /var/www/html/.htaccess && \
	rm -rf /tmp

# Install Apache and PHP extensions
RUN a2enmod rewrite && \
	docker-php-ext-install gettext

VOLUME /var/www/html/_public

EXPOSE 80