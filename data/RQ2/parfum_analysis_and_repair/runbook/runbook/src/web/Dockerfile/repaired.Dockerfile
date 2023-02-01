#######################################
### Runbook.io - Web App Dockerfile ###
#######################################


# Pull base image
FROM ubuntu:14.04

# Update
RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y python python-dev python-pip python-virtualenv wget unzip build-essential libssl-dev libffi-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

# Install python

RUN rm -rf /var/lib/apt/lists/*


# Create working directory
RUN mkdir -p /code/instance /config
ADD requirements.txt /config/requirements.txt
ADD instance/web.cfg /config/web.cfg
# Install requirements
RUN pip install --no-cache-dir -r /config/requirements.txt

CMD python /code/web.py /config/web.cfg
