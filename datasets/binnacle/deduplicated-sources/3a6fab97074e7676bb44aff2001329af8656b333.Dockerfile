FROM cluster-base

RUN wget --no-check-certificate --no-cookies http://dev.mysql.com/get/Downloads/MySQL-5.1/mysql-5.1.41.tar.gz \
    && tar -zxvf /mysql-5.1.41.tar.gz -C /usr/local \
    && mv /usr/local/mysql-5.1.41 /usr/local/mysql \
    && rm /mysql-5.1.41.tar.gz
