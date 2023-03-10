FROM ubuntu:latest

RUN apt-get -y update


RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install curl wget vim nginx php-fpm libssl1.0 gnupg gcc g++ make autoconf libc-dev pkg-config php-pear php-soap && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f -s https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update
RUN ACCEPT_EULA=Y apt-get --no-install-recommends -y install msodbcsql17 mssql-tools unixodbc-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install php7.2-dev && rm -rf /var/lib/apt/lists/*;

RUN pecl install sqlsrv && pecl install pdo_sqlsrv

RUN echo extension=sqlsrv.so > /etc/php/7.2/fpm/conf.d/sqlsrv.ini
RUN echo extension=pdo_sqlsrv.so > /etc/php/7.2/fpm/conf.d/pdo_sqlsrv.ini

RUN apt-get -y --no-install-recommends install php-curl php-mbstring php-xml php-zip && rm -rf /var/lib/apt/lists/*;

COPY default /etc/nginx/sites-available/default
RUN mkdir /var/www/uploads
RUN chown -R root:root /var/www/


# ADD web/html/ /var/www/html/
# ADD web/miniProxy/ /var/www/miniProxy/
VOLUME [ "/var/www/" ]
ADD default /var/www/default.backup

RUN chmod o+wx /var/www/uploads
RUN chmod o-r /var/www/uploads


CMD service php7.2-fpm start && service nginx start && /bin/bash
