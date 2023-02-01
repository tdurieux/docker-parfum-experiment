# Basic docker based environment
# Necessary to trick dokku into building the documentation
# using dockerfile instead of herokuish
FROM ubuntu:21.10

ENV TZ="Etc/UTC"
RUN apt-get update && \
  apt-get install --no-install-recommends -y tzdata && \
  ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
  dpkg-reconfigure -f noninteractive tzdata && rm -rf /var/lib/apt/lists/*;

# Add basic tools
RUN apt-get update && \
  apt-get install --no-install-recommends -y build-essential \
    software-properties-common \
    curl \
    git \
    libxml2 \
    libffi-dev \
    libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    php8.1-cli \
    php8.1-mbstring \
    php8.1-xml \
    php8.1-zip \
    php8.1-intl \
    php8.1-opcache \
    php8.1-sqlite \
    php8.1-curl \
    composer && rm -rf /var/lib/apt/lists/*;

# This prevents permission errors with the mounted vendor directory.
RUN git config --global --add safe.directory /code/vendor/cakephp/cakephp

WORKDIR /code

VOLUME ["/code"]

CMD [ "/bin/bash" ]
