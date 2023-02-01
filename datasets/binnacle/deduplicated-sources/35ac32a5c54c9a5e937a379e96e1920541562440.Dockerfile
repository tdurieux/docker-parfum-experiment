ARG SLURM_VER=17.02
FROM brianmay/slurm:${SLURM_VER}
MAINTAINER brian@linuxpenguins.xyz

# Install OS dependencies
RUN apt-get update \
  && apt-get install -y \
    gcc sudo libcrack2-dev \
    apache2 \
    apache2-dev \
    libapache2-mod-shib2 \
  && rm -rf /var/lib/apt/lists/*

RUN pip install mod_wsgi && \
  mod_wsgi-express module-config > /etc/apache2/mods-available/wsgi.load && \
  a2enmod wsgi

#RUN wget -O /tmp/mod_wsgi.tar.gz https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/modwsgi/mod_wsgi-3.4.tar.gz && \
#    tar -C /tmp -xvf /tmp/mod_wsgi.tar.gz && \
#    rm /tmp/mod_wsgi.tar.gz &&
#    cd /tmp/mod_wsgi-3.4 &&
#    ln -s /usr/lib/libpython3.6m.so /usr/lib/libpython3.6.so && \
#    ./configure --with-python=/usr/local/bin/python3.6 --with-apxs=/usr/bin/apxs && \
#    make && make install clean && \
#    cd /srv && \
#    rm -rf /tmp/mod_wsgi-3.4

# Make application directory
RUN mkdir /opt/karaage /opt/karaage/requirements
WORKDIR /opt/karaage

# Install our requirements.
RUN pip install pipenv
ADD Pipfile Pipfile.lock /opt/karaage/
RUN pipenv install --system --deploy

# Copy all our files into the image.
COPY . /opt/karaage/
COPY conf/karaage3-wsgi.conf /etc/apache2/conf-available/karaage3-wsgi.conf
COPY conf/ports.conf /etc/apache2/ports.conf
COPY conf/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enconf karaage3-wsgi

# Setup access to version information
ARG BUILD_DATE=
ARG VCS_REF=
ENV BUILD_DATE=${BUILD_DATE}
ENV VCS_REF=${VCS_REF}
ENV SLURM_VER=${SLURM_VER}

# Specify the command to run when the image is run.
EXPOSE 443
VOLUME '/etc/shibboleth' '/var/log'
CMD /opt/karaage/scripts/docker.sh apache
