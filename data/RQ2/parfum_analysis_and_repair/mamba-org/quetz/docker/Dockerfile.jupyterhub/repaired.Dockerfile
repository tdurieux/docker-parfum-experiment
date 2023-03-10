FROM jupyterhub/jupyterhub

# openssl passwd -1 test
RUN useradd testuser --no-log-init -u 1000 -p "$(openssl passwd -1 test)"
COPY jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py