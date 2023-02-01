# For building PHP from source for debugging purposes (specifically used in troubleshooting Issue #98)
FROM ubuntu:19.10
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install --no-install-recommends -y apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y perl-modules && rm -rf /var/lib/apt/lists/*;
RUN apt upgrade -y
RUN apt install --no-install-recommends -y libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libzip-dev libldap2-dev libxml2-dev libpng-dev libicu-dev libbz2-dev libtidy-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libmemcached-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y autoconf automake re2c libtool bison && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y curl wget && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
RUN git clone https://git.php.net/repository/php-src.git
RUN apt install --no-install-recommends -y sendmail gawk && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libcurl4-openssl-dev zlibc libgd-dev libfreetype6 libjpeg9 libgdbm-dev libsodium-dev mysql-common mysql-client postgresql-11 libreadline5 libreadline-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
