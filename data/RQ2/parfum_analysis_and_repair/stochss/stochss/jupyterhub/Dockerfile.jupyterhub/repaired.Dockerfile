ARG JUPYTERHUB_VERSION
#FROM jupyterhub/jupyterhub-onbuild:$JUPYTERHUB_VERSION
FROM ubuntu:18.04

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update  && apt-get install -yq --no-install-recommends \
        ca-certificates \
        curl \
        gnupg \
        locales \
        python3-pip \
        python3-pycurl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ENV SHELL=/bin/bash LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

RUN locale-gen $LC_ALL

RUN python3 -m pip install --no-cache --upgrade setuptools pip

RUN npm install -g configurable-http-proxy@^4.2.0 && rm -rf ~/.npm && npm cache clean --force;

RUN mkdir -p /srv/jupyterhub/

RUN mkdir -p /srv/userlist/

WORKDIR /srv/jupyterhub

EXPOSE 8000

# Install dockerspawner, oauth, postgres
RUN python3 -m pip install --no-cache-dir \
        jupyterhub==1.1.0 \
        oauthenticator==0.11.* \
        dockerspawner==0.11.* \
        psycopg2==2.7.* \
        nbviewer==1.0.1 \
        notebook \
        gillespy2==1.6.3

COPY static/*    /usr/local/share/jupyterhub/static/

COPY custom/favicon.ico /usr/local/share/jupyterhub/static/favicon.ico

COPY custom/custom.js    /opt/stochss-config/.jupyter/custom/custom.js

COPY cull_idle_servers.py /srv/jupyterhub/cull_idle_servers.py

CMD ["jupyterhub" "-f" "/srv/jupyterhub/jupyterhub_config.py"]
