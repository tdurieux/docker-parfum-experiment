FROM debian:jessie


RUN apt-get update -y && apt-get install --no-install-recommends -y --force-yes \
    php5 \
    php5-mysql \
    php5-json \
    php5-xsl \
    php5-intl \
    php5-mcrypt \
    php5-gd \
    php5-curl \
    patch && rm -rf /var/lib/apt/lists/*;


ADD ezpublish.yml_varnishpurge.diff /
ADD run.sh /

WORKDIR /var/www


CMD /run.sh
