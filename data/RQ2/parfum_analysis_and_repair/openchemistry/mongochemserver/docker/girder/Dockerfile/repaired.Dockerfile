FROM girder/girder:3.1.0

# Install cumulus
RUN git clone https://github.com/Kitware/cumulus.git /cumulus && \
  pip install --no-cache-dir -r /cumulus/requirements.txt && \
  pip install --no-cache-dir -e /cumulus && \
  pip install --no-cache-dir -e /cumulus/girder/cumulus && \
  pip install --no-cache-dir -e /cumulus/girder/sftp && \
  pip install --no-cache-dir -e /cumulus/girder/newt && \
  pip install --no-cache-dir -e /cumulus/girder/taskflow

# Set the broker URL
RUN sed -i s/localhost/rabbitmq/g /cumulus/cumulus/celery/commonconfig.py

COPY docker/girder/config.json /cumulus/cumulus/conf/config.json

RUN git clone https://github.com/OpenChemistry/openchemistrypy.git /openchemistrypy

# Enable proxy support
COPY docker/girder/girder.local.conf /etc/girder.cfg

# Copy over mongochemserver
COPY . /mongochemserver

# Install mongochemserver
RUN pip install --no-cache-dir -e /mongochemserver/girder/molecules && \
  pip install --no-cache-dir -e /mongochemserver/girder/notebooks && \
  pip install --no-cache-dir -e /mongochemserver/girder/queues && \
  pip install --no-cache-dir -e /mongochemserver/girder/app && \
  pip install --no-cache-dir -e /mongochemserver/girder/images

# Install OAuth plugin
RUN pip install --no-cache-dir -e /girder/plugins/oauth

# Install autojoin plugin, needed to share clusters via groups
RUN pip install --no-cache-dir -e /girder/plugins/autojoin

# Rebuild the Girder UI
RUN girder build

# Install clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
