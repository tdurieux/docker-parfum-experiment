#++++++++++++++++++++++++++++++++++++++
# Solr Docker container
#++++++++++++++++++++++++++++++++++++++
#
# Images:
#
#   guywithnose/solr
#       https://hub.docker.com/r/guywithnose/solr/
#
#++++++++++++++++++++++++++++++++++++++

FROM guywithnose/solr:4.9.0
ENV DEBIAN_FRONTEND noninteractive

ADD entrypoint.sh /entrypoint.sh

COPY ./conf/ /opt/solr-conf/

# Download plugin
RUN curl -sf -o /tmp/solr-typo3-plugin.jar -L http://www.typo3-solr.com/fileadmin/files/solr/solr-typo3-plugin-1.3.0.jar

# Init directories
RUN cp -a /opt/solr-conf/* /opt/solr/example/solr/ \
    && mkdir -p /opt/solr/example/solr/typo3cores/data \
    && mkdir -p /opt/solr/example/solr/typo3lib

# Add plugins
RUN mv /tmp/solr-typo3-plugin.jar /opt/solr/example/solr/typo3lib/ \
    && ln -s /opt/solr/contrib    /opt/solr/example/solr/contrib

# Fix rights
RUN chown solr:solr -R /opt/solr/example/solr/

VOLUME "/opt/solr/server/solr/data"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["solr"]
