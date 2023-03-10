#################################################
# BOWTIE

# Largery based on dukegcb/bowtie
# All commands are the same as the ones from the base image
# To obtain the results in the final folder, simply run
# License: Apache License 2.0
#################################################


FROM dukegcb/bowtie
MAINTAINER Carlos Redondo <carlos.red@utexas.edu>
ENV _SECOND_AUTHOR "Carlos Redondo <carlos.red@utexas.edu"

# BOINC requires access to the /root/ folder
USER root


WORKDIR /data


# Installs realpath command so that the program can access the full path information of files


# Copies the unaccounted files to /root/shared/results
COPY Mov_Res.py /Mov_Res.py

# The python program will only move text files out, not binary or compressed (tar, zip) files


RUN apt-get update && apt-get install --no-install-recommends curl wget python python-pip unzip -y && \
    pip install --no-cache-dir --upgrade pip && python -m pip install binaryornot && \
    mkdir -p /root/shared/results && touch /All_outs.txt && \
	for afil in $(find /data -name '*.txt'); do printf "$(realpath $afil)\n" >>  /All_outs.txt; done && rm -rf /var/lib/apt/lists/*;
