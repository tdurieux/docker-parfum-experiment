ARG python_ver=3.7
FROM python:${python_ver}

ARG netbox_ver=master
ENV PYTHONUNBUFFERED 1

RUN mkdir -p /opt

RUN pip install --no-cache-dir --upgrade pip

# -------------------------------------------------------------------------------------
# Install NetBox
# -------------------------------------------------------------------------------------
RUN git clone --single-branch --branch ${netbox_ver} https://github.com/netbox-community/netbox.git /opt/netbox/ && \
    cd /opt/netbox/ && \
    pip install --no-cache-dir -r /opt/netbox/requirements.txt

# Work around https://github.com/rq/django-rq/issues/421
RUN pip install --no-cache-dir django-rq==2.3.2

# -------------------------------------------------------------------------------------
# Install Netbox Plugin
# -------------------------------------------------------------------------------------
RUN mkdir -p /source
WORKDIR /source
COPY . /source

#RUN pip install -r requirements.txt
RUN python setup.py develop

WORKDIR /opt/netbox/netbox/