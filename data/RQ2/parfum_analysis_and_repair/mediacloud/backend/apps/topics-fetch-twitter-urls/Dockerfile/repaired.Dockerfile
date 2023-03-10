#
# Fetch Twitter URLs
#

FROM gcr.io/mcback/topics-base:latest

# Copy sources
COPY src/ /opt/mediacloud/src/topics-fetch-twitter-urls/
ENV PERL5LIB="/opt/mediacloud/src/topics-fetch-twitter-urls/perl:${PERL5LIB}" \
	PYTHONPATH="/opt/mediacloud/src/topics-fetch-twitter-urls/python:${PYTHONPATH}"

# Copy worker script