#################################################
# CUDA GPU image

# All commands are the same as the ones from the base image

#################################################



FROM nvidia/cuda


MAINTAINER Carlos Redondo <carlos.red@utexas.edu>
ENV _SECOND_AUTHOR "Carlos Redondo <carlos.red@utexas.edu"



# Copies the unaccounted files to /root/shared/results
COPY Mov_Res.py /Mov_Res.py

RUN apt-get update && apt-get install --no-install-recommends python python3 python3-pip curl wget tar unzip -y && \
    mkdir -p /root/shared/results && rm -rf /var/lib/apt/lists/*;


WORKDIR /data
