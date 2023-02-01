FROM ppc64le/ubuntu:16.04 

MAINTAINER Snehlata Mohite <smohite@us.ibm.com>

# Install Odoo
ENV ODOO_VERSION 10.0
ENV ODOO_RELEASE 20170207

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
		node-less \            
        python-gevent \
        python-pip \
        python-renderpm \
        python-watchdog \
		wkhtmltopdf\
        && apt-get -y install -f --no-install-recommends \
        && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb \
        && pip install --upgrade pip && pip install setuptools &&  pip install psycogreen==1.0\
	    && curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
        && echo '5d2fb0cc03fa0795a7b2186bb341caa74d372e82 odoo.deb' | sha1sum -c - \
        && dpkg --force-depends -i odoo.deb \
        && apt-get update \
        && apt-get -y install -f --no-install-recommends \
        && rm -rf /var/lib/apt/lists/* odoo.deb\
		&& apt-get purge -y --auto-remove curl

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN chmod +x /entrypoint.sh\
    && chown odoo /etc/odoo/odoo.conf\
    && mkdir -p /mnt/extra-addons \
    && chown -R odoo /mnt/extra-addons

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
