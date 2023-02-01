FROM jupyterhub/jupyterhub:1.4.2
# https://hub.docker.com/layers/jupyterhub/jupyterhub

# pkgs
RUN python3 -m pip install --upgrade --no-cache pip && \
    python3 -m pip install --no-cache \
	   jupyter_client \
       dockerspawner \
       jupyterhub-idle-culler &&\
    rm -rf /tmp/*
# jupyterhub-nativeauthenticator

# nativeauthenticator
RUN apt-get update && \
    apt-get install --no-install-recommends -y git && \
    cd /tmp && \
    git clone https://github.com/jupyterhub/nativeauthenticator.git && \
    cd nativeauthenticator && \
    pip install --no-cache-dir -e . && \
    cd ~/ && rm -rf /var/lib/apt/lists/*;

# config -----------------------------------------------------------------#
USER root
RUN mkdir -p /srv/jupyterhub/ &&\
    mkdir -p /opt/jupyterhub/
WORKDIR /srv/jupyterhub

# EXPOSE 8888
COPY ./jupyterhub_config.py /opt/jupyterhub/jupyterhub_config.py
CMD ["jupyterhub", "-f", "/opt/jupyterhub/jupyterhub_config.py"]

# docker build -t shichenxie/dstudio_hub:1.4.2 -f Dockerfile1.4 .
# docker save shichenxie/dstudio_hub:1.2.2 -o ~/Downloads/dstudio_hub.tar