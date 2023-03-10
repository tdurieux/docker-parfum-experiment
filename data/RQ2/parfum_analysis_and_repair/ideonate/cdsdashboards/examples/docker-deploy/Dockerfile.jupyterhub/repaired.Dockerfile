ARG JUPYTERHUB_VERSION
ARG BASE_IMAGE=jupyterhub/jupyterhub:${JUPYTERHUB_VERSION}

FROM ${BASE_IMAGE}

# Copy TLS certificate and key
ENV SSL_CERT /srv/jupyterhub/secrets/jupyterhub.crt
ENV SSL_KEY /srv/jupyterhub/secrets/jupyterhub.key
COPY ./secrets/*.crt $SSL_CERT
COPY ./secrets/*.key $SSL_KEY
RUN chmod 700 /srv/jupyterhub/secrets && \
    chmod 600 /srv/jupyterhub/secrets/*

COPY ./userlist /srv/jupyterhub/userlist

COPY ./jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py