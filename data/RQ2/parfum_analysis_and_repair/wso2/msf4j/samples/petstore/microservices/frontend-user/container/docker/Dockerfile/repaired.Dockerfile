From ubuntu:14.04

RUN sudo apt-get update && apt-get install --no-install-recommends -y apache2 php5 php5-curl php5-redis && rm -rf /var/lib/apt/lists/*;

RUN sudo apt-get install --no-install-recommends -y openssh-server git vim && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/run/sshd
RUN echo 'root:stratos' | chpasswd
RUN sed -i "s/PermitRootLogin without-password/#PermitRootLogin without-password/" /etc/ssh/sshd_config
EXPOSE 22

expose 80

RUN rm -fr /var/www/html/*
COPY html /var/www/html/
#COPY php.ini /etc/php5/apache2/
COPY init.sh /opt/
RUN chmod 755 /opt/init.sh
ENTRYPOINT /opt/init.sh
