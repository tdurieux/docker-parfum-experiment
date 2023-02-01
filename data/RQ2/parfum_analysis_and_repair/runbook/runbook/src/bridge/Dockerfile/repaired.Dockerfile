######################################
### Runbook.io - Bridge Dockerfile ###
######################################


# Pull base image
FROM ubuntu:14.04

# Update
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y python python-dev python-pip python-virtualenv wget unzip libssl-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

# Install python

RUN rm -rf /var/lib/apt/lists/*


# Create working directory
RUN mkdir -p /code /config
ADD requirements.txt /config/requirements.txt
ADD config/config.yml /config/config.yml

# Install requirements
RUN pip install --no-cache-dir -r /config/requirements.txt

CMD python /code/mgmtscripts/create_db.py /config/config.yml && \
    python /code/bridge.py /config/config.yml
