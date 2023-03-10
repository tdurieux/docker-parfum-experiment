# To check running container: docker exec -it fence /bin/bash

# (pauline, 07/20/2020) Dockerfile for the fence-shib image.
# This Dockerfile is NOT compatible yet with the latest Fence (Python 3
# and depdencency management via Poetry) - for now, use Fence 2.7.x.

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    apache2 \
    build-essential \
    curl \
    git \
    # for ftp
    lftp \
    # for decryption dbgap files
    mcrypt \
    libapache2-mod-wsgi \
    # shibboleth module for eRA login
    libapache2-mod-shib2 \
    # dependency for cryptography
    libffi-dev \
    # dependency for pyscopg2 - which is dependency for sqlalchemy postgres engine
    libpq-dev \
    # dependency for cryptography
    libssl-dev \
    python2.7 \
    python-dev \
    python-pip \
    python-setuptools \
    vim \
    && pip install --no-cache-dir pip==9.0.3 \
    && pip install --no-cache-dir --upgrade setuptools \
    && mkdir /var/www/fence \
    && mkdir -p /var/www/.cache/Python-Eggs/ \
    && chown www-data -R /var/www/.cache/Python-Eggs/ && rm -rf /var/lib/apt/lists/*;

COPY . /fence
WORKDIR /fence
#
# Custom apache24 logging - see http://www.loadbalancer.org/blog/apache-and-x-forwarded-for-headers/
#
RUN ln -s /fence/wsgi.py /var/www/fence/wsgi.py \
    && pip install --no-cache-dir -r requirements.txt \
    && COMMIT=`git rev-parse HEAD` && echo "COMMIT=\"${COMMIT}\"" >fence/version_data.py \
    && VERSION=`git describe --always --tags` && echo "VERSION=\"${VERSION}\"" >>fence/version_data.py \
    && python setup.py develop \
    && echo '<VirtualHost *:80>\n\
    ServerName SERVERNAME \n\
    WSGIDaemonProcess /fence processes=2 threads=4 python-path=/var/www/fence/:/fence/:/usr/bin/python\n\
    WSGIScriptAlias / /var/www/fence/wsgi.py\n\
    WSGIPassAuthorization On\n\
    <Directory "/var/www/fence/">\n\
        WSGIProcessGroup /fence\n\
        WSGIApplicationGroup %{GLOBAL}\n\
        Options +ExecCGI\n\
        Order deny,allow\n\
        Allow from all\n\
    </Directory>\n\
    <Location />\n\
      <IfModule mod_shib>\n\
        AuthType shibboleth\n\
        ShibRequireSession Off\n\
        ShibUseHeaders On\n\
        require shibboleth\n\
      </IfModule>\n\
    </Location>\n\
    ErrorLog ${APACHE_LOG_DIR}/error.log\n\
    LogLevel info\n\
    LogFormat "%{X-Forwarded-For}i %l %{X-UserId}i %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"" aws\n\
    SetEnvIf X-Forwarded-For "^..*" forwarded\n\
    CustomLog ${APACHE_LOG_DIR}/access.log combined env=!forwarded\n\
    CustomLog ${APACHE_LOG_DIR}/access.log aws env=forwarded\n\
</VirtualHost>\n'\
>> /etc/apache2/sites-available/fence.conf \
    && a2dissite 000-default \
    && a2ensite fence \
    && a2enmod reqtimeout \
    && ln -sf /dev/stdout /var/log/shibboleth/shibd.log \
    && ln -sf /dev/stdout /var/log/shibboleth/shibd_warn.log \
    && ln -sf /dev/stdout /var/log/shibboleth/signature.log \
    && ln -sf /dev/stdout /var/log/shibboleth/transaction.log \
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

EXPOSE 80
WORKDIR /var/www/fence/

CMD bash /fence/dockerrunshib.bash
