ARG MET_BASE_IMAGE=minimum

FROM dtcenter/met-base:${MET_BASE_IMAGE}
MAINTAINER John Halley Gotway <johnhg@ucar.edu>

#
# Set the working directory.
#
WORKDIR /met

#
# Download and install MET and GhostScript fonts.
# Delete the MET source code for tagged releases matching "v"*.
#
RUN echo "Installing tools needed for running MET unit tests..." \
 && echo "Installing Perl XML Parser..." \
 && yum makecache \
 && yum -y install perl-XML-Parser \
 && echo "Installing R..." \
 && yum -y install R \
 && echo "Installing R ncdf4 1.19..." \
 && wget https://cran.r-project.org/src/contrib/ncdf4_1.19.tar.gz \
 && R CMD INSTALL ncdf4_1.19.tar.gz \
 && echo "Installing NCO (for ncdiff)..." \
 && yum -y install nco \
 && echo "Finished installing unit test tools" && rm -rf /var/cache/yum
