# Ubuntu image
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /web
RUN apt-get update -y && apt-get install --no-install-recommends -y apt-utils openssl zip unzip git tzdata && rm -rf /var/lib/apt/lists/*;

RUN  echo "Europe/Dublin" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

# Install nginx
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

#Install PHP
RUN apt-get install --no-install-recommends -y curl php7.2-cli php7.2-fpm php7.2-curl php7.2-gd php7.2-pgsql php7.2-mbstring zip unzip php7.2-xml php7.2-xdebug && rm -rf /var/lib/apt/lists/*;


#Install Nodejs
RUN apt-get install --no-install-recommends -y nodejs npm && rm -rf /var/lib/apt/lists/*;


RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Lua dependencies
RUN apt-get install --no-install-recommends -y lua50 && rm -rf /var/lib/apt/lists/*; # Lua intepreter
RUN apt-get install --no-install-recommends -y luarocks && rm -rf /var/lib/apt/lists/*; # Lua package manager
RUN apt-get install --no-install-recommends -y luajit && rm -rf /var/lib/apt/lists/*; # Lua JIT compiler to validate syntax
RUN luarocks install luaunit        # LuaUnit library



COPY . /web

RUN composer install

# Run the server
CMD php artisan serve --env=testing --host=0.0.0.0 --port=8000
