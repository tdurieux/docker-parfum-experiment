# base image
ARG BASE_IMAGE=mahara-base:impish
FROM ${BASE_IMAGE}

# enviroment variable as non interactive
ARG DEBIAN_FRONTEND=noninteractive

# update packages
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      apache2 \
      libapache2-mod-php \
      poppler-utils && rm -rf /var/lib/apt/lists/*;

RUN sed -i "s/^upload_max_filesize = .*/upload_max_filesize = 99M/; s/^post_max_size = .*/post_max_size = 100M/" /etc/php/*/cli/php.ini \
    && sed -i "s/^upload_max_filesize = .*/upload_max_filesize = 99M/; s/^post_max_size = .*/post_max_size = 100M/" /etc/php/*/apache2/php.ini

# Make the apache access.log and error.log files sym links to stdout/stderr.
# This makes all the logging appear in `docker container logs`
RUN ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log

COPY htdocs /mahara/htdocs
COPY docker/web/etc/apache2/ /etc/apache2/

# - sym link the config.php from config-environment.ph
# - disable the apache2 service because the container will run that process in the foreground.
# - disable the default site and enable the Mahara site.
RUN cd /mahara/htdocs && ln -sf config-environment.php config.php && \
    update-rc.d apache2 disable && a2dissite 000-default && a2ensite mahara-http

Expose 80

# Run apache to bring up Mahara
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
