# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER Adrian Moreno <adrian.moreno@emc.com>

# Update the sources list
RUN apt-get update

# Install Python and Basic Python Tools
RUN apt-get install --no-install-recommends -y python python-dev python-distribute python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential git curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nginx gunicorn && rm -rf /var/lib/apt/lists/*;

# Copy the application folder inside the container
ADD . /app/mosaicme-web

# Get pip to download and install requirements:
RUN pip install --no-cache-dir -r /app/mosaicme-web/requirements.txt

# Set environment variables
ENV PYTHONPATH /app/mosaicme-web:$PYTHON_PATH

# setup all the config files
run rm /etc/nginx/sites-enabled/default
run ln -s /app/mosaicme-web/mosaicme_nginx.conf /etc/nginx/sites-enabled/mosaicme

# Set the default directory where CMD will execute
WORKDIR /app/mosaicme-web

# Expose ports
EXPOSE 80

CMD sh start.sh
