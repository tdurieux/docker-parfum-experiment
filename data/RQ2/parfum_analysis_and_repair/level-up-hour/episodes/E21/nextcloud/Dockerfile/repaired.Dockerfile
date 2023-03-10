FROM registry.access.redhat.com/ubi8/php-74

USER root
RUN yum -y install php-gd php-xml \
    php-mbstring php-intl php-pecl-apcu php-mysqlnd \
    php-opcache php-json php-zip \
    iproute procps less && \
    yum clean all && rm -rf /var/cache/yum

USER 1001
# Add application sources
# for some reason this is being added as root
ADD ./nextcloud-20.0.2.tar.xz /tmp/
ADD launch.sh /opt/launch.sh
USER root

#for debugging
#RUN ls -l /tmp/nextcloud || :
#RUN ls -l /opt/app-root/src || :

RUN chmod g+w -R /opt/app-root/src
RUN chown -R 1001:0 /tmp/nextcloud
RUN chown 1001:0 /opt/launch.sh
RUN chmod a+x /opt/launch.sh
#back to real user
USER 1001
CMD /opt/launch.sh
