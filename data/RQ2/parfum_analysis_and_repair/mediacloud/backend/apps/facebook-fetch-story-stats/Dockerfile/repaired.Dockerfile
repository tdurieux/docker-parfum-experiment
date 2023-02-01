#
# Fetch story stats from Facebook
#

FROM gcr.io/mcback/common:latest

# Copy sources
COPY src/ /opt/mediacloud/src/facebook-fetch-story-stats/
ENV PERL5LIB="/opt/mediacloud/src/facebook-fetch-story-stats/perl:${PERL5LIB}" \
    PYTHONPATH="/opt/mediacloud/src/facebook-fetch-story-stats/python:${PYTHONPATH}"

# Copy worker script