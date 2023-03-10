FROM php:8.0-cli

# Requirements for running phpunit
RUN apt-get update && apt-get install --no-install-recommends -y git zip && rm -rf /var/lib/apt/lists/*;
RUN pecl install xdebug-3.0.2 && docker-php-ext-enable xdebug
ENV XDEBUG_MODE=coverage
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Build a mercurial project
RUN apt-get install --no-install-recommends -y mercurial && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp \
 && hg init test \
 && cd test \
 && touch Foo.php \
 && hg add Foo.php \
 && hg --config ui.username="John Doe" commit Foo.php -m "First commit" \
 && echo '<?php class Foo {}' > Foo.php \
 && echo '<?php class Bar {}' > Bar.php \
 && hg add Bar.php \
 && hg --config ui.username="John Doe" commit Foo.php Bar.php -m "2nd commit"

COPY churn.yml /tmp/test/
