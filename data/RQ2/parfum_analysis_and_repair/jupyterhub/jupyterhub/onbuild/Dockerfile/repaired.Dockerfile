# JupyterHub Dockerfile that loads your jupyterhub_config.py
#
# Adds ONBUILD step to jupyter/jupyterhub to load your jupyterhub_config.py into the image
#
# Derivative images must have jupyterhub_config.py next to the Dockerfile.