FROM keensoft/centos7-java8
MAINTAINER keensoft.es

RUN set -x \
	&& yum update -y \
	&& yum install -y \
		unzip \
		lsof \
	&& yum clean all

ENV SOLR6_DOWNLOAD_URL https://download.alfresco.com/release/community/201702-build-00016/alfresco-search-services-1.0.0.zip
ENV SOLR_DIR /usr/local/solr

RUN set -x \
	&& mkdir -p $SOLR_DIR \
	&& wget --no-check-certificate $SOLR6_DOWNLOAD_URL \
	&& unzip alfresco-search-services-1.0.0.zip \
	&& mv alfresco-search-services/* $SOLR_DIR \
	&& rm -rf alfresco-search-services*

COPY assets/templates/rerank/conf/solrcore.properties $SOLR_DIR/solrhome/templates/rerank/conf/solrcore.properties
COPY assets/run.sh $SOLR_DIR/run.sh
WORKDIR $SOLR_DIR
ENV PATH $SOLR_DIR/solr/bin:$PATH

RUN useradd -ms /bin/bash solr
RUN set -x && chown -RL solr:solr $SOLR_DIR
USER solr

EXPOSE 8983
CMD ["run"]
ENTRYPOINT ["./run.sh"]
