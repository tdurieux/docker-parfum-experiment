# runnable base
FROM boxcar/raring

# REPOS
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y -q software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -y update --fix-missing

#SHIMS
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

# EDITORS
RUN apt-get install --no-install-recommends -y -q vim nano && rm -rf /var/lib/apt/lists/*;

# TOOLS
RUN apt-get install --no-install-recommends -y -q curl git make wget && rm -rf /var/lib/apt/lists/*;

# BUILD
RUN apt-get install --no-install-recommends -y -q build-essential g++ && rm -rf /var/lib/apt/lists/*;

# SERVICES

## MEMCACHED
RUN apt-get install --no-install-recommends -y -q memcached && rm -rf /var/lib/apt/lists/*;


## APACHE
RUN apt-get install --no-install-recommends -y -q apache2 && rm -rf /var/lib/apt/lists/*;

## MYSQL
RUN apt-get install --no-install-recommends -y -q mysql-client mysql-server && rm -rf /var/lib/apt/lists/*;

# LANGS

## PYTHON
RUN apt-get install --no-install-recommends -y -q python-software-properties python python-setuptools python-virtualenv python-dev python-distribute python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip --no-input --no-cache-dir --exists-action=w install --upgrade pip

# LIBS
RUN apt-get install --no-install-recommends -y -q libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms1-dev libwebp-dev libtiff-dev && rm -rf /var/lib/apt/lists/*;

## NODE
RUN apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

## APP
ADD app /root

RUN apt-get -y update --fix-missing
