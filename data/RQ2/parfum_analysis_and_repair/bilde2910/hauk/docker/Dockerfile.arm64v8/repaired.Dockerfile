#------------------------------------------------------------------------------#
# DO NOT BUILD THIS FILE DIRECTLY!                                             #
#------------------------------------------------------------------------------#
# This Dockerfile is for automated builds on Docker Hub only. If you want to   #
# build the Hauk backend for aarch64, you should instead build the main        #
# Dockerfile in the root of the repository on an aarch64-capable CPU.          #
#                                                                              #
# If you want to cross-compile Hauk for aarch64 on a non-aarch64 CPU, and you  #
# are absolutely certain that you know what you are doing and that this is     #
# what you want to do: you must have qemu-user-static binaries installed and   #
# registered on your build system.                                             #
#                                                                              #
# Then change the FROM instruction in the root Dockerfile (NOT *this* file) so #
# that it pulls arm64v8/php:apache instead of php:apache to ensure you fetch   #
# Apache and PHP from upstream for the right architecture.                     #
#------------------------------------------------------------------------------#

FROM    arm64v8/php:apache
COPY    qemu-aarch64-static /usr/bin
COPY    backend-php/ /var/www/html/
COPY    frontend/ /var/www/html/
COPY    docker/start.sh .

RUN apt-get update && \
        apt-get install --no-install-recommends -y memcached libmemcached-dev zlib1g-dev libldap2-dev && \
        pecl install memcached && \
        docker-php-ext-enable memcached && \
        docker-php-ext-configure ldap --with-libdir=lib/*-linux-gnu*/ && \
        docker-php-ext-install ldap && rm -rf /var/lib/apt/lists/*;

EXPOSE  80/tcp
VOLUME  /etc/hauk

STOPSIGNAL SIGINT
RUN     chmod +x ./start.sh
RUN     rm -f /usr/bin/qemu-aarch64-static
CMD     ["./start.sh"]
