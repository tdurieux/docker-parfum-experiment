# vistalab/jupyterhub
#
# Create a Stanford kerberized jupyterhub container with matplotlib (and deps) installed.
#
# Example usage:
#   docker run --rm -p 80:8000 vistalab/jupyterhub
#
# USER ACCOUNTS:
#   User accounts can be added by running the adduser_jupyter.sh script in this directory.
#  
#   Example:
#       ./adduser_jupyter.sh jupyter lmperry
#

# TODO: Copy a list of users to create in the contianer
# TODO: Copy the create script to the container
# TODO: Run a command to create each user inside the container
#

FROM jupyter/jupyterhub:latest

MAINTAINER Michael Perry <lmperry@stanford.edu>

# Kerberize and install python libs
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \
    krb5-user libpam-krb5 \
    libpng12-dev libfreetype6-dev \
    libblas-dev liblapack-dev gfortran build-essential python-dev \
    && mv /etc/krb5.conf /etc/krb5.conf.dpkg-dist \
    && wget -O /etc/krb5.conf https://web.stanford.edu/dept/its/support/kerberos/dist/krb5.conf \
    && pip install --no-cache-dir matplotlib \
    && pip install --no-cache-dir numpy \
    && pip install --no-cache-dir scipy \
    && pip install --no-cache-dir nibabel && rm -rf /var/lib/apt/lists/*;

# Make notebook directories and make a soft-link to that directory for new users
RUN mkdir -p /srv/jupyterhub/notebooks/ \
    && ln -s /srv/jupyterhub/notebooks /etc/skel/notebooks

# SSL: Create a self-signed cert on the fly (stop-gap measure)
# An alternative method would be to mount in the host's ssl cert and key (untested)
# https://tools.stanford.edu/cgi-bin/cert-request - to request a host cert.
RUN mkdir -p /srv/jupyterhub/ssl \
    && cd /srv/jupyterhub/ssl \
    && openssl req -new -newkey rsa:2048 -rand /dev/urandom -nodes -keyout jupyter.key -out jupyter.csr -subj "/C=US/ST=California/L=Stanford/O=Global Security/OU=IT Department/CN=stanford.edu" \
    && openssl x509 -req -days 365 -in jupyter.csr -signkey jupyter.key -out jupyter.crt

EXPOSE 8000

ONBUILD ADD jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py

CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]

