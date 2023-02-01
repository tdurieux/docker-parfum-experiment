######################################################################
# (C)Copyright 2021,2022 Hewlett Packard Enterprise Development LP
######################################################################
# This is a sample docker file to build the user ml container

FROM tensorflow/tensorflow:2.7.0

COPY requirements.txt swarmlearning-client-py3-none-manylinux_2_24_x86_64.whl /tmp/swarmlib/

# Install ml environment packages
RUN pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir -r /tmp/swarmlib/requirements.txt

# Install SwarmLearning package
RUN pip3 install --no-cache-dir /tmp/swarmlib/swarmlearning-client-py3-none-manylinux_2_24_x86_64.whl
