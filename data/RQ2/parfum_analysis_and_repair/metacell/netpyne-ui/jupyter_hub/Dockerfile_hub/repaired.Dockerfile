FROM jupyterhub/jupyterhub:latest

# feature_jupyterhub
ARG netpyneuiBranch=feature_jupyterhub
ENV netpyneuiBranch=${netpyneuiBranch} 
RUN echo "$netpyneuiBranch";

# Install authenticator and spawner + jupyter_client
RUN pip install --no-cache-dir jupyterhub-tmpauthenticator dockerspawner jupyter_client

# Overwrite jupyterhub_config
RUN wget https://raw.githubusercontent.com/MetaCell/NetPyNE-UI/$netpyneuiBranch/jupyterhub/jupyterhub_config.py -q