FROM jupyterhub/jupyterhub:1
COPY setup.py /src/dockerspawner/setup.py
COPY requirements.txt /src/dockerspawner/requirements.txt
RUN pip install --no-cache-dir -r /src/dockerspawner/requirements.txt
COPY dockerspawner /src/dockerspawner/dockerspawner
RUN pip install --no-cache-dir /src/dockerspawner
COPY examples/internal-ssl/jupyterhub_config.py /srv/jupyterhub/jupyterhub_config.py
