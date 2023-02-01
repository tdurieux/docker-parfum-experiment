FROM python:3.5

RUN apt-get update && apt-get install --no-install-recommends -y supervisor tree && rm -rf /var/lib/apt/lists/*;

# Set the default directory where CMD will execute
WORKDIR /opt/autologin

# Get pip to download and install requirements
# This comes early because requirements rarely change so this step will be cached
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -r requirements.txt && \
    formasaurus init

ADD . /opt/autologin

# Check that we ADD-ed only the required files
RUN tree

# Finish install
RUN python setup.py install

# Expose ports
EXPOSE 8088 8089

# Create the data folder
RUN mkdir -p /var/autologin

VOLUME /var/autologin

# Copy config to set up the database location
COPY autologin/autologin.docker.cfg /etc/autologin.cfg

# Set the default command to execute when creating a new container
CMD autologin-init-db && supervisord -c /opt/autologin/supervisord.conf
