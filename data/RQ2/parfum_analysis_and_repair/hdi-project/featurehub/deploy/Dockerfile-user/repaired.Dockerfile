FROM jupyterhub/systemuser:0.6.0

# Clean up from existing systemuser setup
RUN rm -rf /home/jovyan

# Upgrade package managers
RUN apt-get update
RUN /opt/conda/bin/pip install --force-reinstall pip==9.0.3

# Install mysql-related packages
RUN apt-get install --no-install-recommends -y libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

# Install autosklearn
RUN apt-get install --no-install-recommends -y build-essential gcc && rm -rf /var/lib/apt/lists/*;
RUN /opt/conda/bin/conda install -y swig libgcc

# Reduce size of final image
RUN rm -rf /var/lib/apt/lists/*

# Install featurehub into site-packages
COPY src /tmp/featurehub/src
RUN cd /tmp/featurehub/src && /opt/conda/bin/pip install .[all]

# Same as jupyterhub/systemuser
CMD ["sh", "/srv/singleuser/systemuser.sh"]
