#################################################
# BLAST

# Largery based on biocontainers/blast
# All commands are the same as the ones from the base image
# To obtain the results in the final folder, simply run
# License: Apache License 2.0

#################################################


FROM biocontainers/blast
MAINTAINER Carlos Redondo <carlos.red@utexas.edu>
ENV _SECOND_AUTHOR "Carlos Redondo <carlos.red@utexas.edu"

# BOINC requires access to the /root/ folder
USER root


# Installs realpath command so that the program can access the full path information of files


# Copies the unaccounted files to /root/shared/results
COPY Mov_Res.py /Mov_Res.py

# The python program will move the .png, .jpg, .jpeg, .txt files out



RUN mkdir -p /root/shared/results && apt-get install --no-install-recommends -y coreutils && touch /All_outs.txt && \
	for afil in $(find /data -name '*.txt'); do printf "$(realpath $afil)\n" >>  /All_outs.txt; done && \
	for afil in $(find /data -name '*.jpeg'); do printf "$(realpath $afil)\n" >>  /All_outs.txt; done && \
	for afil in $(find /data -name '*.jpg'); do printf "$(realpath $afil)\n" >>  /All_outs.txt; done && \
	for afil in $(find /data -name '*.png'); do printf "$(realpath $afil)\n" >>  /All_outs.txt; done && rm -rf /var/lib/apt/lists/*;
