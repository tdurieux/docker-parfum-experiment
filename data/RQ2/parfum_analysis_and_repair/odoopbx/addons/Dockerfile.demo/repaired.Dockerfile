FROM odoopbx/pbx:latest
ARG ODOO_VERSION=15.0
ARG ODOO_DB=odoopbx_15
ENV ODOO_VERSION=$ODOO_VERSION ODOO_DB=$ODOO_DB
ENV POSTGRES_AUTOSTART=true NGINX_AUTOSTART=true MINION_AUTOSTART=false

RUN odoopbx install postgres \
    && odoopbx install odoo \
    && salt-call --local grains.set odoo:addons_init val=asterisk_plus_crm \
    && salt-call --local grains.set odoo:initdb_options val= \
    && odoopbx install odoo.initdb \
    && odoopbx install nginx \
    && echo "ami_host: 127.0.0.1" > /etc/salt/minion_local.conf \
    && echo "odoo_host: 127.0.0.1" >> /etc/salt/minion_local.conf

COPY ./supervisor.conf /etc/supervisor/conf.d/odoo.conf