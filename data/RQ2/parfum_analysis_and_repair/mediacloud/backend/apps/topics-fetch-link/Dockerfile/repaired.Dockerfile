#
# Fetch topic link worker
#

FROM gcr.io/mcback/topics-base:latest

# Copy sources
COPY src/ /opt/mediacloud/src/topics-fetch-link/
ENV PERL5LIB="/opt/mediacloud/src/topics-fetch-link/perl:${PERL5LIB}" \
	PYTHONPATH="/opt/mediacloud/src/topics-fetch-link/python:${PYTHONPATH}"

# Copy worker script