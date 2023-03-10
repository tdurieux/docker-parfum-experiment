# Download base image ubuntu 18.04

FROM ubuntu:18.04

# Update Ubuntu Software repository
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:ondrej/php -y && \
    apt-get -y --no-install-recommends install \
    apt-transport-https \
    apt-utils \
    autoconf \
    curl \
    libcurl4 \
    g++ \
    gcc \
    git \
    lcov \
    libxml2-dev \
    locales \
    make \
    php7.3 \
    php7.3-dev \
    php7.3-intl \
    python-pip \
    re2c \
    unixodbc-dev \
    unzip && apt-get clean && \
    curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl -f https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get -y update && \
    export ACCEPT_EULA=Y && apt-get -y --no-install-recommends install msodbcsql17 mssql-tools && \
    update-alternatives --set php /usr/bin/php7.3 && rm -rf /var/lib/apt/lists/*;

ARG PHPSQLDIR=/REPO/msphpsql-dev
ENV TEST_PHP_SQL_SERVER sql
ENV TEST_PHP_SQL_UID sa
ENV TEST_PHP_SQL_PWD Password123

# update PATH after ODBC driver and tools are installed
ENV PATH="/opt/mssql-tools/bin:${PATH}"	

# add locales for testing
RUN sed -i 's/# en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
RUN sed -i 's/# fr_FR@euro ISO-8859-15/fr_FR@euro ISO-8859-15/g' /etc/locale.gen
RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
RUN sed -i 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/g' /etc/locale.gen
RUN sed -i 's/# zh_CN GB2312/zh_CN GB2312/g' /etc/locale.gen
RUN sed -i 's/# zh_CN.GB18030 GB18030/zh_CN.GB18030 GB18030/g' /etc/locale.gen
RUN locale-gen

# set locale to utf-8
# RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# install coveralls (upgrade both pip and requests first)
RUN python -m pip install --upgrade pip
RUN python -m pip install --upgrade requests
RUN python -m pip install cpp-coveralls

# Either Install git / download zip (One can see other strategies : https://ryanfb.github.io/etc/2015/07/29/git_strategies_for_docker.html )
#One option is to get source from zip file of repository.
#another option is to copy source to build directory on image
RUN mkdir -p $PHPSQLDIR
COPY . $PHPSQLDIR
WORKDIR $PHPSQLDIR/source/

RUN chmod +x ./packagize.sh
RUN /bin/bash -c "./packagize.sh"

RUN echo "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.3/mods-available/sqlsrv.ini
RUN echo "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.3/mods-available/pdo_sqlsrv.ini

# create a writable ini file for testing locales
RUN echo '' > `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/99-overrides.ini
RUN chmod 666 `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/99-overrides.ini

WORKDIR $PHPSQLDIR/source/sqlsrv
RUN /usr/bin/phpize && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" LDFLAGS="-lgcov" CXXFLAGS="-O0 --coverage" && make && make install

WORKDIR $PHPSQLDIR/source/pdo_sqlsrv
RUN /usr/bin/phpize && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" LDFLAGS="-lgcov" CXXFLAGS="-O0 --coverage" && make && make install

RUN phpenmod sqlsrv pdo_sqlsrv
RUN php --ri sqlsrv && php --ri pdo_sqlsrv

# set name of sql server host to use
WORKDIR $PHPSQLDIR/test/functional/pdo_sqlsrv
RUN sed -i -e 's/TARGET_SERVER/sql/g' MsSetup.inc
RUN sed -i -e 's/TARGET_DATABASE/msphpsql_pdosqlsrv/g' MsSetup.inc
RUN sed -i -e 's/TARGET_USERNAME/'"$TEST_PHP_SQL_UID"'/g' MsSetup.inc
RUN sed -i -e 's/TARGET_PASSWORD/'"$TEST_PHP_SQL_PWD"'/g' MsSetup.inc

WORKDIR $PHPSQLDIR/test/functional/sqlsrv
RUN sed -i -e 's/TARGET_SERVER/sql/g' MsSetup.inc
RUN sed -i -e 's/TARGET_DATABASE/msphpsql_sqlsrv/g' MsSetup.inc
RUN sed -i -e 's/TARGET_USERNAME/'"$TEST_PHP_SQL_UID"'/g' MsSetup.inc
RUN sed -i -e 's/TARGET_PASSWORD/'"$TEST_PHP_SQL_PWD"'/g' MsSetup.inc

WORKDIR $PHPSQLDIR
RUN chmod +x ./entrypoint.sh
CMD /bin/bash ./entrypoint.sh

ENV REPORT_EXIT_STATUS 1
ENV TEST_PHP_EXECUTABLE /usr/bin/php
