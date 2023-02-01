FROM brightspot/solr:8

# Restore solr into container. To back up (execute from project root):
ADD ./data/solr.tar.gz /var/solr/data/collection1/data
USER root
RUN chown -R solr:solr /var/solr/data/collection1/data
USER solr
VOLUME /var/solr/data/collection1/data