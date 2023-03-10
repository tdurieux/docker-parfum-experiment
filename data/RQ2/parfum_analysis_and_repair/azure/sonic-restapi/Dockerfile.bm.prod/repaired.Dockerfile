FROM rest-api-common

RUN apt-get autoremove -y \
 && apt-get clean \
 && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY supervisor/arp_responder_bm.conf /etc/supervisor/conf.d/
COPY supervisor/rest_api_prod.conf /etc/supervisor/conf.d/