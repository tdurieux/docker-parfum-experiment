# runnable base
FROM boxcar/raring

# REPOS
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y -q software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN apt-get -y update

#SHIMS
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

# EDITORS
RUN apt-get install --no-install-recommends -y -q vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q nano && rm -rf /var/lib/apt/lists/*;

# TOOLS
RUN apt-get install --no-install-recommends -y -q curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q make && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q wget && rm -rf /var/lib/apt/lists/*;

# BUILD
RUN apt-get install --no-install-recommends -y -q build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q g++ && rm -rf /var/lib/apt/lists/*;

# SERVICES

## MEMCACHED
RUN apt-get install --no-install-recommends -y -q memcached && rm -rf /var/lib/apt/lists/*;
#RUN pecl install -y memcache

## MAGICK
RUN apt-get install --no-install-recommends -y -q imagemagick && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q graphicsmagick && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q graphicsmagick-libmagick-dev-compat && rm -rf /var/lib/apt/lists/*;
# #RUN pecl install -y imagick

## APACHE
RUN apt-get install --no-install-recommends -y -q apache2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q libapache2-mod-php5 && rm -rf /var/lib/apt/lists/*;

## MYSQL
RUN apt-get install --no-install-recommends -y -q mysql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q mysql-server && rm -rf /var/lib/apt/lists/*;

# LANGS

## PYTHON
RUN apt-get install --no-install-recommends -y -q python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python-virtualenv && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python-distribute && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip --no-input --no-cache-dir --exists-action=w install --upgrade pip

# LIBS
RUN apt-get install --no-install-recommends -y -q libjpeg8-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q liblcms1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q libwebp-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q libtiff-dev && rm -rf /var/lib/apt/lists/*;

# Django
RUN easy_install django

ENV DEBIAN_FRONTEND dialog