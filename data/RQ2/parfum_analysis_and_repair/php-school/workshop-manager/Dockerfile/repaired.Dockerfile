#
# PHP School
# A revolutionary new way to learn PHP.
# Bring your imagination to life in an open learning eco-system.
# http://phpschool.io
#

FROM php:7-cli
MAINTAINER Michael Woodward <mikeymike.mw@gmail.com>

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    apt-utils \
    zip \
    git \
    vim \
    libzip-dev \
    zlib1g-dev \
    && docker-php-ext-configure zip --with-zlib-dir=/usr \
    && docker-php-ext-install -j$(nproc) zip; rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir /phpschool
ENV PATH /root/.php-school/bin/:$PATH

# Workshop manager
RUN curl -f -O https://php-school.github.io/workshop-manager/workshop-manager.phar \
    && mv workshop-manager.phar /usr/local/bin/workshop-manager \
    && chmod +x /usr/local/bin/workshop-manager \
    && workshop-manager verify

RUN echo PS1=\"\\[\\e[35m\\]$ \\e[0m\\]\" >> ~/.bashrc
RUN echo TERM=xterm >> ~/.bashrc

WORKDIR /phpschool
CMD ["bash"]
