###################################
# Image name: wrfhydro/training:c5_0_0
# Author: Joe Mills <jmills@ucar.edu>
# Date:  2018-05-22
###################################
FROM wrfhydro/dev:base

MAINTAINER jmills@ucar.edu
USER root

############################
#Get the entrypoint script to download the code release