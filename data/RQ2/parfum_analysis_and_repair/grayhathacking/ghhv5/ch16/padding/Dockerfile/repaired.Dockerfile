FROM nimmis/apache-php5

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
 apt-get install --no-install-recommends -y mysql-server mysql-client && rm -rf /var/lib/apt/lists/*;


COPY paddingweb.tar.gz /tmp/
COPY deploy.sql /tmp/

RUN update-rc.d mysql defaults && service mysql start && sleep 2 && mysql < /tmp/deploy.sql
RUN printf "[program:mysql]\ncommand=/my_service mysql\n" > /etc/supervisor/conf.d/mysql.conf


RUN cd /tmp && tar -zxvf paddingweb.tar.gz && mv www/* /var/www/html/ && rm /var/www/html/index.html && rm paddingweb.tar.gz



