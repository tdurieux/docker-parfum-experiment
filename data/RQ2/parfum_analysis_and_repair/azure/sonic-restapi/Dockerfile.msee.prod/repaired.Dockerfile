FROM rest-api-common

RUN apt-get -y --no-install-recommends install libqt5network5 && rm -rf /var/lib/apt/lists/*;

COPY supervisor/arp_responder_msee.conf /etc/supervisor/conf.d/
COPY supervisor/rest_api_prod.conf /etc/supervisor/conf.d/

COPY debs/libthrift-0.9.3_0.9.3-2_amd64.deb /tmp
RUN dpkg -i /tmp/libthrift-0.9.3_0.9.3-2_amd64.deb ; rm -f /tmp/*.deb

RUN apt-get autoremove -y \
 && apt-get clean \
 && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/*
