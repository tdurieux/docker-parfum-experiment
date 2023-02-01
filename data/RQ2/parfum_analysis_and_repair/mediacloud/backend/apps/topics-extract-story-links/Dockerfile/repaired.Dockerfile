#
# Extract story links worker
#

FROM gcr.io/mcback/topics-base:latest

# Copy sources
COPY src/ /opt/mediacloud/src/topics-extract-story-links/
ENV PERL5LIB="/opt/mediacloud/src/topics-extract-story-links/perl:${PERL5LIB}" \
    PYTHONPATH="/opt/mediacloud/src/topics-extract-story-links/python:${PYTHONPATH}"

# Copy worker script