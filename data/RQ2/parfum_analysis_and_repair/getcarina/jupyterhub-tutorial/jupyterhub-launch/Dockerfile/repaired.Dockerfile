FROM jupyter/jupyterhub:0.4.1

RUN pip install --no-cache-dir dockerspawner==0.2 oauthenticator
