#################################################
# HTSeq

# Largery based on gromacs/gromacs
# All commands are the same as the ones from the base image
# To obtain the results in the final folder, simply run
# License: Apache License 2.0

#################################################


FROM ubuntu:16.04
MAINTAINER Carlos Redondo <carlos.red@utexas.edu>
ENV _SECOND_AUTHOR "Carlos Redondo <carlos.red@utexas.edu"

# BOINC requires access to the /root/ folder
USER root


# Installs realpath command so that the program can access the full path information of files


# Copies the unaccounted files to /root/shared/results
COPY Mov_Res.py /Mov_Res.py

# The python program will move the .png, .jpg, .jpeg, .txt files out

WORKDIR /gromacs


# Obtains the necessary libraries
# Permanently exports the docker file when using bash
# BOINC still requires another source add 'source /usr/local/gromacs/bin/GMXRC.bash' at the start of run command

RUN apt-get update && apt-get install --no-install-recommends build-essential unzip curl wget gcc g++ cmake libboost-all-dev -y && \
    curl -f -O ftp://ftp.gromacs.org/pub/gromacs/gromacs-5.0.7.tar.gz && \
    tar xfz gromacs-5.0.7.tar.gz && \
    cd gromacs-5.0.7 && \
    mkdir build && \
    cd build && \
    cmake .. -DGMX_BUILD_OWN_FFTW=ON -DREGRESSIONTEST_DOWNLOAD=ON && \
    make && \
    make check && \
    make install && \
    printf "\nsource /usr/local/gromacs/bin/GMXRC.bash\n" >> /root/.bashrc && rm gromacs-5.0.7.tar.gz && rm -rf /var/lib/apt/lists/*;


WORKDIR /data

RUN mkdir -p /root/shared/results && apt-get install --no-install-recommends -y coreutils && touch /All_outs.txt && \
	for afil in $(find /data -name '*.txt'); do printf "$(realpath $afil)\n" >>  /All_outs.txt; done && \
	for afil in $(find /data -name '*.jpeg'); do printf "$(realpath $afil)\n" >>  /All_outs.txt; done && \
	for afil in $(find /data -name '*.jpg'); do printf "$(realpath $afil)\n" >>  /All_outs.txt; done && \
	for afil in $(find /data -name '*.png'); do printf "$(realpath $afil)\n" >>  /All_outs.txt; done && rm -rf /var/lib/apt/lists/*;
