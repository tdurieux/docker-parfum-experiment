# Start with the base Ubuntu 12.04 image
FROM ubuntu:12.04
MAINTAINER Ben Whaley "bwhaley@gmail.com"

# Patch the system
RUN apt-get -y update && apt-get -y --no-install-recommends install python-pip gcc python-dev && rm -rf /var/lib/apt/lists/*; # Install pip


# Install uwsgi python application server
RUN pip install --no-cache-dir uwsgi

# Copy the package dependencies
ADD requirements.txt /tmp/requirements.txt

# Install python dependencies
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Clean up dependency file
RUN rm /tmp/requirements.txt
