# arxiv/search-index
#
# Runtime for bulk indexing of a large number of records. This is not used in
# version 0.1, but is available for exploratory work in Kubernetes.
#
# Expects a path to a list of newline-delimited arXiv IDs (versionless).
#
# Example (local stack):
#
#    $ mkdir /tmp/to_index
#    $ cp arxiv_id_dump.txt /tmp/to_index
#    $ docker run -it --network=arxivsearch_es_stack \
#    >   -v /tmp/to_index:/to_index \
#    >   -e ELASTICSEARCH_SERVICE_HOST=elasticsearch \
#    >   arxiv/search-index /to_index/arxiv_id_dump.txt
#
# See also ELASTICSEARCH_* and METADATA_ENDPOINT parameters, below.