FROM centos:centos7

# Update and install required software
RUN yum -y update
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y install git curl ldns bind-utils wget which nginx jq && rm -rf /var/cache/yum
RUN yum -y install ftp vsftpd && rm -rf /var/cache/yum
RUN yum -y install openssh-server && rm -rf /var/cache/yum

# Set locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /root
RUN mkdir -p /etc/nginx/pki/private
COPY ./test/test-config/nginx-ubuntu-no-ssl /etc/nginx/conf.d/default.conf
COPY ./test/test-config/nginx-centos7.conf /etc/nginx/nginx.conf

# Setup ftp
ENV VSFTPD_CONF=/etc/vsftpd/vsftpd.conf
ENV FTP_PASSIVE_DEFAULT=true
COPY test/test-config/vsftpd.conf /etc/vsftpd/vsftpd.conf
RUN adduser ftpuser
RUN echo 'ftpuser:ftpuser' | chpasswd
RUN adduser www-data
RUN usermod -G www-data ftpuser
RUN usermod -G www-data root
RUN mkdir -p /var/www/.well-known/acme-challenge
RUN chown -R www-data.www-data /var/www
RUN chmod g+w -R /var/www

# BATS (Bash Automated Testings)
RUN git clone --depth 1 https://github.com/bats-core/bats-core.git /bats-core
RUN git clone --depth 1 https://github.com/bats-core/bats-support /bats-support
RUN git clone --depth 1 https://github.com/bats-core/bats-assert /bats-assert
RUN /bats-core/install.sh /usr/local
