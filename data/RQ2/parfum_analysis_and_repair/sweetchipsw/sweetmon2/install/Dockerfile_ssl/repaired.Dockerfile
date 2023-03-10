FROM ubuntu:16.04
MAINTAINER sweetchip <sweetchip@sweetchip.kr>

ENV LOCATION=/app
ARG MYSQL_DATABASE
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG LANG
ARG LC_ALL
ENV MYSQL_DATABASE $MYSQL_DATABASE
ENV MYSQL_USER $MYSQL_USER
ENV MYSQL_PASSWORD $MYSQL_PASSWORD
ENV LANG $LANG
ENV LC_ALL $LC_ALL

# Update system
RUN apt update && apt install --no-install-recommends -y python3 python3-pip apache2 virtualenv libapache2-mod-wsgi-py3 git python3-pymysql gettext-base libmysqlclient-dev && rm -rf /var/lib/apt/lists/*; #RUN apt upgrade -y


# Make working directory and go to /app
RUN mkdir -p /app
WORKDIR /app

# Copy sweetmon into image
ADD ./ /app/sweetmon2

# Copy files into Docker.
COPY ./install/sweetmon2_ssl.conf /etc/apache2/sites-available/sweetmon2.conf
COPY ./install/cert/* /cert/

# Apache2 setting
RUN a2dissite 000-default
RUN a2ensite sweetmon2
RUN a2enmod ssl
RUN service apache2 restart

# Initialize sweetmon
WORKDIR /app/sweetmon2
RUN pip3 install --no-cache-dir -r requirements.txt

# Create upload directories
#RUN mkdir -p /data/file/crash/
#RUN mkdir -p /data/file/users/
#RUN mkdir -p /data/file/image/

# Set Permission
WORKDIR /app
RUN echo "[*] Initialize file permissions."
RUN chown www-data:www-data ./ -R

EXPOSE 443

# Run apache
CMD ["apachectl", "-D", "FOREGROUND"]