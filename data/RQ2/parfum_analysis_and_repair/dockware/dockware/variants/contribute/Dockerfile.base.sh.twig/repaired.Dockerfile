{% extends "template/Dockerfile.global.sh.twig" %}


{% block shopware_install %}
## ***********************************************************************
##  INSTALL SHOPWARE
## ***********************************************************************
RUN git clone --branch={{ shopware.dev.branch }} https://github.com/shopware/development /var/www/shopware && \
    git clone --branch={{ shopware.platform.branch }} https://github.com/shopware/platform /var/www/platform && \
    cp -a /var/www/shopware/. /var/www/html/ && \
    rm -rf /var/www/shopware && \
    cp -a /var/www/platform/. /var/www/html/platform && \
    rm -rf /var/www/platform && \
    cd /var/www/html && \
    composer install
{% endblock %}


{% block shopware_prepare %}
{% set env_file = '/var/www/html/.env' %}
{% set psh_override_file = '/var/www/html/.psh.yaml.override' %}

RUN echo "APP_ENV=dev" >> {{ env_file }} && \
    echo "APP_SECRET=1" >> /{{ env_file }} && \
    echo "INSTANCE_ID=1" >> {{ env_file }} && \
    echo "DATABASE_URL=mysql://{{ db.user }}:{{ db.pwd }}@{{ db.host }}:{{ db.port }}/{{ db.database }}" >> {{ env_file }} && \
    echo "APP_URL={{ shopware.url }}" >> {{ env_file }} && \
    echo "MAILER_URL=smtp://localhost:1025" >> {{ env_file }} && \
    echo "COMPOSER_HOME=/var/www/html/var/cache/composer" >> {{ env_file }} && \
    echo "SHOPWARE_ES_ENABLED=0" >> {{ env_file }} && \
    echo "const:" >> {{ psh_override_file }} && \
    echo '     APP_ENV: "dev"' >> {{ psh_override_file }} && \
    echo '     APP_URL: "{{ shopware.url }}"' >> {{ psh_override_file }} && \
    echo '     DB_HOST: "{{ db.host }}"' >> {{ psh_override_file }} && \
    echo '     DB_PORT: "{{ db.port }}"' >> {{ psh_override_file }} && \
    echo '     DB_NAME: "{{ db.database }}"' >> {{ psh_override_file }} && \
    echo '     DB_USER: "{{ db.user }}"' >> {{ psh_override_file }} && \
    echo '     DB_PASSWORD: "{{ db.pwd }}"' >> {{ psh_override_file }} && \
    cd /var/www/scripts/shopware6 && php create_jwt.php && \
    chown www-data:www-data /var/www/html/config/jwt/*

RUN service mysql start && \
    # install shopware by
    # using the official psh command
    cd /var/www/html && ls -la && \
    export COMPOSER_HOME="/var/www/.composer" && \
    ./psh.phar install

{% endblock %}


{% block shopware_dev %}
{# dont do anything in here, no dev prepare stuff#}
{% endblock %}