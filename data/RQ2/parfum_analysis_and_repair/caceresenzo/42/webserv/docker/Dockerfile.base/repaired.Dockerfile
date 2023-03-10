FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install --no-install-recommends -y nano git wget zsh valgrind clang make nginx dos2unix && rm -rf /var/lib/apt/lists/*;

RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

RUN apt-get install --no-install-recommends -y php php-cgi php-mysql && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN cd /root && \
	wget https://wordpress.org/latest.zip && \
	unzip latest.zip

RUN apt-get install --no-install-recommends -y mysql-server-5.7 mysql-client-5.7 && rm -rf /var/lib/apt/lists/*;
RUN service mysql start; \
	mysql -u root -e "CREATE DATABASE wordpress;"; \
	mysql -u root -e "UPDATE mysql.user SET plugin='mysql_native_password';"; \
	mysql -u root -e "UPDATE mysql.user SET host = '%' WHERE USER = 'root';"; \
	mysql -u root -e "UPDATE mysql.user SET authentication_string=PASSWORD(\"password\") WHERE user='root';"; \
	mysql -u root -e "SELECT host, user, plugin, authentication_string FROM mysql.user WHERE user='root';"; \
	mysql -u root -e "FLUSH PRIVILEGES;";

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.2/cgi/php.ini

RUN mkdir /app

WORKDIR /app
EXPOSE 80

ONBUILD COPY . /app