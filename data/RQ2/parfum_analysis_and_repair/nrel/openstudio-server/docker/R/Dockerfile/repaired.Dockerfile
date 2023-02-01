# AUTHOR:           Nicholas Long
# DESCRIPTION:      OpenStudio Server R Container
# TO_BUILD_AND_RUN: docker-compose up

FROM nrel/openstudio-r:4.2.0
MAINTAINER Nicholas Long nicholas.long@nrel.gov

# Add in the additional R packages
ADD /install_packages.R install_packages.R
RUN Rscript install_packages.R

# Install custom packages
ADD /lib/R-packages /opt/openstudio/R/lib/R-packages
RUN R CMD INSTALL /opt/openstudio/R/lib/R-packages/NRELmoo*.tar.gz /opt/openstudio/R/lib/R-packages/NRELpso*.tar.gz /opt/openstudio/R/lib/R-packages/NRELGA*.tar.gz

# Add the remaining files
ADD /lib /opt/openstudio/R/lib

# Install Gems