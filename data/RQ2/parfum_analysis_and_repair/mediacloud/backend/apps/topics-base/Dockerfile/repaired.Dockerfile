#
# Base image for topic-related code
#

FROM gcr.io/mcback/extract-and-vector:latest

USER root

# Install dependencies
RUN \


    apt-get -y --no-install-recommends install libre2-dev && \
    #
    true && rm -rf /var/lib/apt/lists/*;

# Install Python dependencies
COPY src/requirements.txt /var/tmp/
RUN \
    cd /var/tmp/ && \
    #
    # Install the rest of the stuff
    pip3 install --no-cache-dir -r requirements.txt && \
    rm requirements.txt && \
    rm -rf /root/.cache/ && \
    true

# Copy sources
COPY src/ /opt/mediacloud/src/topics-base/
ENV PERL5LIB="/opt/mediacloud/src/topics-base/perl:${PERL5LIB}" \
    PYTHONPATH="/opt/mediacloud/src/topics-base/python:${PYTHONPATH}"
