FROM python:3.7

RUN pip install --no-cache-dir --upgrade pip

# Install netbox.
RUN mkdir -p /opt
RUN git clone --branch v3.1.6 https://github.com/netbox-community/netbox.git /opt/netbox/ && \
    cd /opt/netbox/ && \
    pip install --no-cache-dir -r /opt/netbox/requirements.txt && \
    pip install --no-cache-dir jsonschema==3.2.0 && \
    pip install --no-cache-dir netbox-bgp==0.5.0

# Copy entrypoint script.
COPY dev/entrypoint.sh /opt/netbox/entrypoint.sh

# Work around https://github.com/rq/django-rq/issues/421
RUN pip install --no-cache-dir django-rq==2.3.2

# Install the plugin in develop mode.
RUN mkdir -p /netbox-virtual-circuit-plugin
WORKDIR /netbox-virtual-circuit-plugin
COPY . /netbox-virtual-circuit-plugin
RUN python3 setup.py develop

WORKDIR /opt/netbox/netbox/
