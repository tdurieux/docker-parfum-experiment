{% extends "variants/dev/Dockerfile.base.sh.twig" %}

{% block shopware_install %}
## ***********************************************************************
##  INSTALL SHOPWARE
## ***********************************************************************
RUN mkdir /var/www/shopware && \
    chown www-data:www-data /var/www/shopware &&\
    sudo -u www-data sh -c  'git clone --branch=6.3 https://github.com/shopware/production.git /var/www/shopware' && \
    # lock to commit that fixes composer post install "--no-cleanup" bug
    cd /var/www/shopware && sudo -u www-data git checkout 49d625cdd5437e2f0bd297f05a951ad5af437374 && \
    cd /var/www/shopware && rm -rf .git && \
    cd /var/www/shopware && rm -rf .gitlab-ci && \
    cd /var/www/shopware && rm -rf .gitlab-ci.yml && \
    sudo -u www-data sh -c 'cp -a /var/www/shopware/. /var/www/html/' && \
    rm -rf /var/www/shopware && \
    # ------------------------------------------------------------------
    # lock to shopware 6.3.0.1
    sudo -u www-data sed -i 's#~v6.3.0#v6.3.0.1#g' /var/www/html/composer.json && \
    rm -rf /var/www/html/composer.lock && \
    # ------------------------------------------------------------------
    # install everything
    cd /var/www/html &&  sudo -u www-data composer install
{% endblock %}


{% block shopware_dev_install %}
{% endblock %}