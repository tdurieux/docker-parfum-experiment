#base image
FROM ubuntu:20.04

MAINTAINER OriginTrail
LABEL maintainer="OriginTrail"
ENV NODE_ENV=testnet

#Install git, nodejs, mysql, python
RUN apt-get -qq update && apt-get -qq --no-install-recommends -y install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get -qq update
RUN apt-get -qq --no-install-recommends -y install wget apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq --no-install-recommends -y install git nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends mysql-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq --no-install-recommends -y install unzip nano && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq --no-install-recommends -y install make python && rm -rf /var/lib/apt/lists/*;

#Install Papertrail
RUN wget https://github.com/papertrail/remote_syslog2/releases/download/v0.20/remote_syslog_linux_amd64.tar.gz
RUN tar xzf ./remote_syslog_linux_amd64.tar.gz && cd remote_syslog && cp ./remote_syslog /usr/local/bin && rm ./remote_syslog_linux_amd64.tar.gz
COPY config/papertrail.yml /etc/log_files.yml



#Install nodemon
RUN npm install -g forever && npm cache clean --force;


WORKDIR /ot-node

COPY . .


#Install npm
RUN npm install && npm cache clean --force;


#Intialize mysql
RUN usermod -d /var/lib/mysql/ mysql
RUN echo "disable_log_bin" >> /etc/mysql/mysql.conf.d/mysqld.cnf
RUN service mysql start && mysql -u root  -e "CREATE DATABASE operationaldb /*\!40100 DEFAULT CHARACTER SET utf8 */; update mysql.user set plugin = 'mysql_native_password' where User='root'/*\!40100 DEFAULT CHARACTER SET utf8 */; flush privileges;" && npx sequelize --config=./config/sequelizeConfig.js db:migrate

