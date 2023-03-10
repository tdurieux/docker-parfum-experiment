#################################################
# NAMD

# Only useful for namd2 with or without charmrun in a CPU setting
# All commands are the same as the ones from the base image
# To obtain the results in the final folder, simply run
# License: Apache License 2.0
# DO NOT USE the flag ++local, will throw an error

# This software includes code developed by the Theoretical Biophysics Group
# in the Beckman Institute for Advanced Science and Technology at the
# University of Illinois at Urbana-Champaign.

#################################################


FROM ubuntu:16.04
MAINTAINER Carlos Redondo <carlos.red@utexas.edu>
ENV _SECOND_AUTHOR "Carlos Redondo <carlos.red@utexas.edu"
ENV _COPYRIGHT_NOTICE "This software includes code developed by the Theoretical Biophysics Group \
in the Beckman Institute for Advanced Science and Technology at the \
University of Illinois at Urbana-Champaign."

# Because the previous user is Ubuntu and BOINC requires access to the /root/ folder
USER root


# Installs realpath command so that the program can access the full path information of stuff
# The container already accounts fro the known .out files and saves their names accordingly
# There will be a file to move all the unaccounted .out files to the /root/shared/results folder
# Then, it changes their type to .txt files


# Copies the unaccounted files to /root/shared/results
COPY Mov_Res.py /Mov_Res.py

COPY NAMD_Linux-x86_64-multicore.tar.gz /build/NAMD_Linux-x86_64-multicore.tar.gz

# Compiles namd and charmrun into a binary which can be called directly
# Adds a python command to move the results into the BOINC container
# User is still responsible for making sure that all results are available in the /data directory

RUN cd /build &&\
    tar -xvzf NAMD_Linux-x86_64-multicore.tar.gz &&\
    cd NAMD* &&\
    cp namd2 /usr/local/bin/namd2 && cp charmrun /usr/local/bin/charmrun &&\
    apt-get update && apt-get install --no-install-recommends unzip curl wget python -y && \
    mkdir -p /root/shared/results && touch /All_outs.txt && mkdir /data && \
	for afil in $(find /data -name '*.txt'); do printf "$(realpath $afil)\n" >>  /All_outs.txt; done && rm NAMD_Linux-x86_64-multicore.tar.gz && rm -rf /var/lib/apt/lists/*;

WORKDIR /data
