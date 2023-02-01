#base image
FROM node:14.18.3-bullseye

MAINTAINER OriginTrail
LABEL maintainer="OriginTrail"
ENV NODE_ENV=testnet


#Mysql-server installation
ARG DEBIAN_FRONTEND=noninteractive
ARG PASSWORD=password
RUN apt-get update
RUN apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget gnupg curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -LO https://dev.mysql.com/get/mysql-apt-config_0.8.20-1_all.deb
RUN dpkg -i ./mysql-apt-config_0.8.20-1_all.deb
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29


RUN { \
     echo mysql-server mysql-server/root_password password $PASSWORD ''; \
     echo mysql-server mysql-server/root_password_again password $PASSWORD ''; \
} | debconf-set-selections \
    && apt-get update && apt-get install --no-install-recommends -y default-mysql-server default-mysql-server-core && rm -rf /var/lib/apt/lists/*;



RUN apt-get -qq --no-install-recommends -y install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq --no-install-recommends -y install make python && rm -rf /var/lib/apt/lists/*;

#Install Papertrail
RUN wget https://github.com/papertrail/remote_syslog2/releases/download/v0.20/remote_syslog_linux_amd64.tar.gz
RUN tar xzf ./remote_syslog_linux_amd64.tar.gz && cd remote_syslog && cp ./remote_syslog /usr/local/bin && rm ./remote_syslog_linux_amd64.tar.gz
COPY config/papertrail.yml /etc/log_files.yml






#Install nodemon & forever
RUN npm install forever -g && npm cache clean --force;




WORKDIR /ot-node

COPY . .

#Install nppm
RUN npm install && npm cache clean --force;

#Mysql intialization
RUN service mariadb start && mysql -u root  -e "CREATE DATABASE operationaldb /*\!40100 DEFAULT CHARACTER SET utf8 */; SET PASSWORD FOR root@localhost = PASSWORD(''); FLUSH PRIVILEGES;" && npx sequelize --config=./config/sequelizeConfig.js db:migrate

