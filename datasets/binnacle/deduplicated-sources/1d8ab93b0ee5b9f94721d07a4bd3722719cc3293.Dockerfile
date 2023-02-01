FROM ubuntu:xenial
MAINTAINER Markos Vakondios <mvakondios@gmail.com> Riley Schuit <riley.schuit@gmail.com>

# Resynchronize the package index files
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    apache2 \
    build-essential \
    cmake \
    dh-autoreconf \
    dpatch \
    git \
    libapache2-mod-php \
    libarchive-zip-perl \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavformat-dev \
    libavresample-dev \
    libav-tools \
    libavutil-dev \
    libbz2-dev \
    libcurl4-gnutls-dev \
    libdate-manip-perl \
    libdbd-mysql-perl \
    libdbi-perl \
    libdevice-serialport-perl \
    libgcrypt-dev \
    libgnutls-openssl-dev \
    libjpeg-turbo8 \
    libjpeg-turbo8-dev \
    libmime-lite-perl \
    libmime-perl \
    libmp4v2-dev \
    libmysqlclient-dev \
    libnet-sftp-foreign-perl \
    libnetpbm10-dev \
    libpcre3 \
    libpcre3-dev \
    libpolkit-gobject-1-dev \
    libpostproc-dev \
    libssl-dev \
    libswscale-dev \
    libsys-cpu-perl \
    libsys-meminfo-perl \
    libsys-mmap-perl \
    libtheora-dev \
    libtool \
    libv4l-dev \
    libvlc5 \
    libvlccore8 \
    libvlccore-dev \
    libvlc-dev \
    libvorbis-dev \
    libvpx-dev \
    libwww-perl \
    libjson-any-perl \
    libjson-maybexs-perl \
    libnumber-bytes-human-perl \
    libsoap-wsdl-perl \
    libio-socket-multicast-perl \
    libphp-serialization-perl \
    libimage-info-perl \
    liburi-encode-perl \
    libdata-dump-perl \
    libclass-std-fast-perl \
    libdigest-sha-perl \
    libdata-uuid-perl \
    libfile-slurp-perl \
    libcrypt-eksblowfish-perl \
    libdata-entropy-perl \
    perl-modules \
    libx264-dev \
    mysql-client \
    mysql-server \
    php \
    php-cli \
    php-gd \
    php-mysql \
    ssmtp \
    software-properties-common \
    vlc-data \
    yasm \
    zip \
    && add-apt-repository -y ppa:iconnor/zoneminder \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    php-apcu-bc \
    && rm -rf /var/lib/apt/lists/*

# Get the latest master branch and submodule(s)
RUN git clone --recursive https://github.com/ZoneMinder/ZoneMinder

# Change into the ZoneMinder directory
WORKDIR /ZoneMinder

# Configure ZoneMinder
RUN cmake .

# Build & install ZoneMinder
RUN make && make install

# ensure writable folders
RUN ./zmlinkcontent.sh

# Set our volumes before we attempt to configure apache
VOLUME /var/lib/zoneminder/events /var/lib/mysql /var/log/zm

# Stop Apache and Mysql before we configure them
RUN service mysql stop && service apache2 stop

# Configure Apache
RUN cp misc/apache.conf /etc/apache2/sites-available/000-default.conf
RUN echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf && a2enconf -q servername
RUN a2enmod -q rewrite && a2enmod -q cgi

# Configure mysql
# No longer needed for zm >= 1.32.0
#RUN echo "sql_mode=NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# Expose http port
EXPOSE 80

# Get the entrypoint script and make sure it is executable
ADD https://raw.githubusercontent.com/ZoneMinder/zmdockerfiles/master/utils/entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh

# This is run each time the container is started
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

################
# RUN EXAMPLES #
################

# ZoneMinder uses /dev/shm for shared memory and many users will need to increase 
# the size significantly at runtime like so:
#
# docker run -d -t -p 1080:80 \
#    --shm-size="512m" \
#    --name zoneminder \
#    zoneminder/zoneminder

# ZoneMinder checks the TZ environment variable at runtime to determine the timezone.
# If this variable is not set, then ZoneMinder will default to UTC.
# Alternaitvely, the timezone can be set manually like so:
#
# docker run -d -t -p 1080:80 \
#    -e TZ='America/Los_Angeles' \
#    --name zoneminder \
#    zoneminder/zoneminder

# ZoneMinder can write its data to folders outside the container using volumes.
#
# docker run -d -t -p 1080:80 \
#    -v /disk/zoneminder/events:/var/lib/zoneminder/events \
#    -v /disk/zoneminder/mysql:/var/lib/mysql \
#    -v /disk/zoneminder/logs:/var/log/zm \
#    --name zoneminder \
#    zoneminder/zoneminder

# ZoneMinder can use an external database by setting the appropriate environment variables.
#
# docker run -d -t -p 1080:80 \
#    -e ZM_DB_USER='zmuser' \
#    -e ZM_DB_PASS='zmpassword' \
#    -e ZM_DB_NAME='zoneminder_database' \
#    -e ZM_DB_HOST='my_central_db_server' \
#    -v /disk/zoneminder/events:/var/lib/zoneminder/events \
#    -v /disk/zoneminder/logs:/var/log/zm \
#    --name zoneminder \
#    zoneminder/zoneminder

# Here is an example using the options described above with the internal database:
#
# docker run -d -t -p 1080:80 \
#    -e TZ='America/Los_Angeles' \
#    -v /disk/zoneminder/events:/var/lib/zoneminder/events \
#    -v /disk/zoneminder/mysql:/var/lib/mysql \
#    -v /disk/zoneminder/logs:/var/log/zm \
#    --shm-size="512m" \
#    --name zoneminder \
#    zoneminder/zoneminder

# Here is an example using the options described above with an external database:
#
# docker run -d -t -p 1080:80 \
#    -e TZ='America/Los_Angeles' \
#    -e ZM_DB_user='zmuser' \
#    -e ZM_DB_PASS='zmpassword' \
#    -e ZM_DB_NAME='zoneminder_database' \
#    -e ZM_DB_HOST='my_central_db_server' \
#    -v /disk/zoneminder/events:/var/lib/zoneminder/events \
#    -v /disk/zoneminder/logs:/var/log/zm \
#    --shm-size="512m" \
#    --name zoneminder \
#    zoneminder/zoneminder

#######################
# Email Notifications #
#######################
#
# Zoneminder can notify you via email but for this SSMTP needs to be configured.
#
# 1. Copy the ssmtp.conf from your container to your local directory.
#    $ docker cp zoneminder:/etc/ssmtp/ssmtp.conf .
# 2. Edit ssmtp.conf to match your SMTP server and email addresses
# 3. Copy the modified ssmtpt.conf back into the container.
#    $ docker cp ssmtp.conf zoneminder:/etc/ssmtp/ssmtp.conf
# 4. In the ZM Console Options, set
#    - Email->NEW_MAIL_MODULES to enabled
#    - Email->SSMTP_MAIL to enabled
#    - Email->SSMTP_PATH to /usr/sbin/ssmtp
# 5. Create an Email sending event filter as described in the docs 
#    http://zoneminder.readthedocs.io/en/stable/userguide/filterevents.html

