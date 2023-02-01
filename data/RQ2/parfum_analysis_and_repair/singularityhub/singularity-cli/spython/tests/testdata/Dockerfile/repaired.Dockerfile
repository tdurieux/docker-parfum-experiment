FROM python:3.5.1
ENV PYTHONUNBUFFERED 1

################################################################################
# CORE
# Do not modify this section

RUN apt-get update && apt-get install --no-install-recommends -y \
    pkg-config \
    cmake \
    openssl \
    wget \
    git \
    vim && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    anacron \
    autoconf \
    automake \
    libarchive-dev \
    libtool \
    libopenblas-dev \
    libglib2.0-dev \
    gfortran \
    libxml2-dev \
    libxmlsec1-dev \
    libhdf5-dev \
    libgeos-dev \
    libsasl2-dev \
    libldap2-dev \
    squashfs-tools \
    build-essential && rm -rf /var/lib/apt/lists/*;

# Install Singularity
RUN git clone -b vault/release-2.5 https://www.github.com/sylabs/singularity.git
WORKDIR singularity
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && make && make install

# Install Python requirements out of /tmp so not triggered if other contents of /code change
ADD requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /tmp/requirements.txt

ADD . /code/

################################################################################
# PLUGINS
# You are free to comment out those plugins that you don't want to use

# Install LDAP (uncomment if wanted)
# RUN pip install python3-ldap
# RUN pip install django-auth-ldap

# Install Globus (uncomment if wanted)
# RUN /bin/bash /code/scripts/globus/globus-install.sh

# Install SAML (uncomment if wanted)
# RUN pip install python3-saml
# RUN pip install social-auth-core[saml]

################################################################################
# BASE

RUN mkdir -p /code && mkdir -p /code/images
RUN mkdir -p /var/www/images && chmod -R 0755 /code/images/

USER tacos

WORKDIR /code
RUN apt-get remove -y gfortran

RUN apt-get autoremove -y
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install crontab to setup job
RUN echo "0 0 * * * /usr/bin/python /code/manage.py generate_tree" >> /code/cronjob
RUN crontab /code/cronjob
RUN rm /code/cronjob

# Create hashed temporary upload locations
RUN mkdir -p /var/www/images/_upload/{0..9} && chmod 777 -R /var/www/images/_upload

CMD /code/run_uwsgi.sh

EXPOSE 3031
