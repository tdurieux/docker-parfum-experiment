# Start with pre-built Greengrass docker image
FROM amazon/aws-iot-greengrass:1.11.5-1-amazonlinux-x86-64

# Install system dependencies and supporting services for accelerator
# (none so far)
# Install pre-req for docker including system path to docker-compose
RUN amazon-linux-extras install docker && \
    rm -rf /var/cache/amzn2extras

# Setup Greengrass to access docker.sock
RUN chgrp ggc_group /opt && \
    chmod 777 /opt

# Add python packages from requirements.txt
ADD requirements.txt /
WORKDIR /
# Update pip in order to reference new wheels
RUN pip3.7 install --upgrade pip
RUN pip3.7 install -r requirements.txt

# Replace entrypoint with one specific for the accelerator