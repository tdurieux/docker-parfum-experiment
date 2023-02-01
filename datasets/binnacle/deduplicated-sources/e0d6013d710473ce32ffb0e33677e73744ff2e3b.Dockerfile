FROM ubuntu:bionic
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update \
  && apt-get -qq upgrade \
  && apt-get -qq install sudo ca-certificates gnupg supervisor net-tools locales setpriv openjdk-8-jre-headless rlwrap ca-certificates-java crudini adduser expect nginx-light curl rsyslog authbind wget devscripts \
  && echo "LC_ALL=en_US.UTF-8" >>/etc/environment \
  && locale-gen en_US.UTF-8 \
  && adduser --quiet --system --uid 998 --home /var/lib/postgresql --no-create-home --shell /bin/bash --group postgres \
  && adduser --quiet --system --uid 999 --home /var/lib/xroad --no-create-home --shell /bin/bash --group xroad \
  && useradd -m xrd -s /usr/sbin/nologin -p '$6$JeOzaeWnLAQSUVuO$GOJ0wUKSVQnOR4I2JgZxdKr.kMO.YGS21SGaAshaYhayv8kSV9WuIFCZHTGAX8WRRTB/2ojuLnJg4kMoyzpcu1' \
  && echo "xroad-center xroad-common/username string xrd" | debconf-set-selections \
  && apt-get -qq install postgresql postgresql-contrib \
  && apt-get -qq clean

ARG DIST=bionic-current
ARG REPO=https://artifactory.niis.org/xroad-release-deb
ARG REPO_KEY=https://artifactory.niis.org/api/gpg/key/public
ARG COMPONENT=main

ADD ["$REPO_KEY","/tmp/repokey.gpg"]
ADD ["${REPO}/dists/${DIST}/Release","/tmp/Release"]
RUN echo "deb $REPO $DIST $COMPONENT" >/etc/apt/sources.list.d/xroad.list \
  && apt-key add '/tmp/repokey.gpg'

RUN pg_ctlcluster 10 main start \
  && apt-get -qq update \
  && apt-get -qq install xroad-centralserver xroad-autologin \
  && apt-get -qq clean \
  && pg_ctlcluster 10 main stop \
  && nginx -s stop \
  && rm -f /var/run/nginx.pid \
  && rm -rf /tmp/xroad \
  && sed -i 's/proxy_set_header Host $host:$server_port;/proxy_set_header Host $http_host;/' /etc/xroad/nginx/default-xroad.conf

# back up read-only config (for volume support)
RUN mkdir -p /root/etc/xroad \
  && cp -a /etc/xroad/* /root/etc/xroad/ \
  && rm /root/etc/xroad/services/local.conf \
     /root/etc/xroad/conf.d/local.ini \
     /root/etc/xroad/devices.ini \
     /root/etc/xroad/db.properties \
  && dpkg-query --showformat='${Version}' --show xroad-center >/root/VERSION \
  && cp /root/VERSION /etc/xroad/VERSION

#Setup TEST-CA with TSA and OCSP
RUN useradd -m ca -U \
  && useradd -G ca ocsp
COPY home /home
COPY etc /etc
COPY files/init.sh /home/ca/CA/
COPY files/ca.py /home/ca/CA/
COPY files/sign_req.sh /home/ca/CA/
RUN chown -R ca:ca /home/ca/CA \
  && find /home/ca/TSA -type f -exec chmod 0664 {} + \
  && find /home/ca/CA -type f -exec chmod 0740 {} + \
  && chmod 0700 /home/ca/CA/init.sh \
  && mkdir -p /var/log/ \
  && touch /var/log/ocsp.log \
  && chown ca:ca /var/log/ocsp.log \
  && chmod 0664 /var/log/ocsp.log \
  && chmod 0754 /home/ca/CA/ca.py \
  && chmod 0754 /home/ca/CA/sign_req.sh

VOLUME /var/lib/postgresql/10/main
VOLUME /etc/xroad

COPY files/cs-entrypoint.sh /root/entrypoint.sh
COPY --chown=root:root files/cs-xroad.conf /etc/supervisor/conf.d/xroad.conf
CMD ["/root/entrypoint.sh"]

VOLUME /var/lib/postgresql/10/main
VOLUME /etc/xroad
EXPOSE 80 4000
