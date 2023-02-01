#
# Import stories from PostgreSQL to Solr for testing purposes
#

FROM gcr.io/mcback/import-solr-data:latest

USER root

# Copy worker script