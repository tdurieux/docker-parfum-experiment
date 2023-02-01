# Designed to be run as 
# 
# docker run -it -p 8000:8000 jupyterhub/oauthenticator

FROM jupyterhub/jupyterhub

MAINTAINER Project Jupyter <ipython-dev@scipy.org>

# Install oauthenticator from git
RUN python3 -m pip install oauthenticator

# Create oauthenticator directory and put necessary files in it