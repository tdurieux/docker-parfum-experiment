# arxiv/search-agent
#
# The indexing agent is responsible for updating the search index as new
#  article metadata becomes available. Subscribes to a Kinesis stream for
#  notifications about new metadata.

FROM arxiv/search:0.5.6

WORKDIR /opt/arxiv

ENV ELASTICSEARCH_SERVICE_HOST 127.0.0.1
ENV ELASTICSEARCH_SERVICE_PORT 9200
ENV ELASTICSEARCH_SERVICE_PORT_9200_PROTO http
ENV ELASTICSEARCH_INDEX arxiv
ENV ELASTICSEARCH_USER elastic
ENV ELASTICSEARCH_PASSWORD changeme
ENV METADATA_ENDPOINT https://arxiv.org/
ENV LOGLEVEL 20

ENV AWS_ACCESS_KEY_ID ""
ENV AWS_SECRET_ACCESS_KEY ""

VOLUME /checkpoint

ENV KINESIS_STREAM "MetadataIsAvailable"
ENV KINESIS_SHARD_ID "0"
ENV KINESIS_CHECKPOINT_VOLUME "/checkpoint"
ENV KINESIS_START_TYPE "AT_TIMESTAMP"

# Add this module again, so that it's tracked.