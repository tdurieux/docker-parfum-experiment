# DockerFile for PCR-GLOB model. The ini-file should be mounted as config.ini,
# the input data root directory should be mounted as /data
FROM continuumio/anaconda3
LABEL maintainer="Willem van Verseveld <Willem.vanVerseveld@deltares.nl>"

# build