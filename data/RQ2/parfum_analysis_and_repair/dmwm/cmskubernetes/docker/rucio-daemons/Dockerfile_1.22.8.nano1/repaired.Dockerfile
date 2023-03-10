# Copyright European Organization for Nuclear Research (CERN) 2017
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Authors:
# - Eric Vaandering, <ewv@fnal.gov>, 2018

ARG RUCIO_VERSION

FROM rucio/rucio-daemons:release-$RUCIO_VERSION

# Install what's needed out of dmwm/rucio/CMS branch
ADD install_mail_templates.sh /tmp/
RUN /tmp/install_mail_templates.sh

ADD https://raw.githubusercontent.com/dmwm/CMSRucio/master/docker/CMSRucioClient/scripts/cmstfc.py /usr/lib/python2.7/site-packages/cmstfc.py
RUN chmod 755 /usr/lib/python2.7/site-packages/cmstfc.py

## Temporary for restricting Reaper2

ADD https://raw.githubusercontent.com/ericvaandering/rucio/cms_nano4/bin/rucio-reaper2 /root/rucio/bin/rucio-reaper2
ADD https://raw.githubusercontent.com/ericvaandering/rucio/cms_nano4/bin/rucio-reaper2 /usr/bin/rucio-reaper2
ADD https://raw.githubusercontent.com/ericvaandering/rucio/cms_nano4/lib/rucio/daemons/reaper/reaper2.py /usr/lib/python2.7/site-packages/rucio/daemons/reaper/reaper2.py
RUN python -m compileall /usr/lib/python2.7/site-packages/rucio/daemons/reaper/
RUN chmod 755 /root/rucio/bin/rucio-*
RUN chmod 755 /usr/bin/rucio-*

# And rule creation
ADD https://raw.githubusercontent.com/ericvaandering/rucio/cms_nano4/lib/rucio/core/permission/cms.py /usr/lib/python2.7/site-packages/rucio/core/permission/cms.py
RUN python -m compileall /usr/lib/python2.7/site-packages/rucio/core/permission

# Delete checks that it exists
ADD https://raw.githubusercontent.com/ericvaandering/rucio/cms_nano4/lib/rucio/rse/protocols/gfal.py /usr/lib/python2.7/site-packages/rucio/rse/protocols/gfal.py
RUN python -m compileall /usr/lib/python2.7/site-packages/rucio/rse/protocols

# Our schema