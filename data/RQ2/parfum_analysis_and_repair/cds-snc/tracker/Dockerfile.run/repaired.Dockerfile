FROM python:3.6
MAINTAINER David Buckley <david.buckley@cds-snc.ca>
LABEL Description="Track Digital Security Compliance" Vendor="Canadian Digital Service"

RUN pip install --no-cache-dir awscli

ENV DOMAIN_HOME /opt/scan/domain-scan
ENV TRACKER_HOME /opt/scan/tracker
ENV DOMAIN_SCAN_PATH $DOMAIN_HOME/scan
ENV DOMAIN_GATHER_PATH $DOMAIN_HOME/gather

# Pull down the domain-scan repo to /opt/scan/domain-scan
RUN mkdir -p $DOMAIN_HOME && wget -q -O - https://api.github.com/repos/cds-snc/domain-scan/tarball | tar xz --strip-components=1 -C $DOMAIN_HOME

COPY deploy/scan.sh $TRACKER_HOME/deploy/scan.sh
RUN chmod +x $TRACKER_HOME/deploy/scan.sh

# Copy required source and package files
COPY MANIFEST.in $TRACKER_HOME/MANIFEST.in
COPY setup.py $TRACKER_HOME/setup.py
COPY data $TRACKER_HOME/data

# Setup environment
RUN pip install --no-cache-dir $TRACKER_HOME/.
RUN pip install --no-cache-dir -r $DOMAIN_HOME/requirements.txt
RUN pip install --no-cache-dir -r $DOMAIN_HOME/requirements-scanners.txt

# Set entrypoint
ENTRYPOINT $TRACKER_HOME/deploy/scan.sh
