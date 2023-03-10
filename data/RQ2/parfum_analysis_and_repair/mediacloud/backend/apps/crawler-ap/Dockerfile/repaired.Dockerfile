#
# AP crawler
#

FROM gcr.io/mcback/common:latest

# Install Python dependencies
COPY src/requirements.txt /var/tmp/
RUN \
    cd /var/tmp/ && \
    pip3 install --no-cache-dir -r requirements.txt && \
    rm requirements.txt && \
    rm -rf /root/.cache/ && \
    true

# Copy sources
COPY src/ /opt/mediacloud/src/crawler-ap/
ENV PERL5LIB="/opt/mediacloud/src/crawler-ap/perl:${PERL5LIB}" \
    PYTHONPATH="/opt/mediacloud/src/crawler-ap/python:${PYTHONPATH}"

COPY bin /opt/mediacloud/bin

USER mediacloud

CMD ["crawler_ap_worker.py"]
