##############################################################
# Use an initial image where all MIAL Super-Resolution BIDSApp
# dependencies are installed, as a parent image
##############################################################
ARG MAIN_DOCKER
FROM "${MAIN_DOCKER}"

##############################################################
# HPC
##############################################################
ENV LANG C.UTF-8 
ENV LC_ALL C.UTF-8 

##############################################################
# Create input and output directories of the BIDS App
##############################################################
RUN mkdir /bids_dir && \
    chmod -R 777 /bids_dir

RUN mkdir /output_dir && \
    chmod -R 777 /output_dir

##############################################################
# Installation of pyMIALSRTK
##############################################################
# Set the working directory to /opt/mialsuperresolutiontoolkit and install pymialsrtk
WORKDIR /opt/mialsuperresolutiontoolkit
RUN /bin/bash -c 'ls -al && $CONDA_ACTIVATE && pip install .'

# Set the working directory back to /app
WORKDIR /app

# Make nipype profiler happy
RUN chmod -R 777 /app

##############################################################
# Create entrypoint scripts
##############################################################
# Copy BIDSapp python script called by the entrypoint scripts
COPY run.py /app/run.py

# Copy main BIDSapp entrypoint script
COPY entrypoints/run_srr.sh /app/run_srr.sh
RUN chmod 775 /app/run_srr.sh
RUN cat /app/run_srr.sh

# Copy BIDSapp entrypoint script with coverage
COPY entrypoints/run_srr_coverage.sh /app/run_srr_coverage.sh
RUN chmod 775 /app/run_srr_coverage.sh
RUN cat /app/run_srr_coverage.sh

##############################################################
# Display all environment variables
##############################################################
# RUN export

##############################################################
# Make singularity happy
##############################################################
RUN ldconfig

##############################################################
# BIDS App entrypoint script
##############################################################
ENTRYPOINT ["/app/run_srr.sh"]

##############################################################
# Build arguments
##############################################################
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

##############################################################
# Metadata
##############################################################