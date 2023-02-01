############################################################
# Dockerfile to build DESeq2 container images
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu:12.04

# File Author / Maintainer
MAINTAINER Laurent Jourdren

# Add CRAN source to apt
RUN echo "deb http://cran.r-project.org/bin/linux/ubuntu precise/" > /etc/apt/sources.list.d/cran.list

# Add CRAN apt key
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# Update the repository sources list
RUN apt-get update

# Install Latex
RUN apt-get install --yes texlive-latex-base texlive-latex-extra 

# Install libxml2 
RUN apt-get install --yes libxml2-dev

# Install R 3.1.0
RUN apt-get install --yes r-base=3.1.0-1precise0 r-base-core=3.1.0-1precise0 r-base-dev=3.1.0-1precise0 r-base-html=3.1.0-1precise0 r-doc-html=3.1.0-1precise0 r-recommended=3.1.0-1precise0 r-cran-boot=1.3-11-1precise0 r-cran-class=7.3-10-1precise0 r-cran-cluster=1.15.2-1precise0 r-cran-codetools=0.2-8-2precise0 r-cran-foreign=0.8.61-1precise0 r-cran-kernsmooth=2.23-12-1precise0 r-cran-lattice=0.20-29-1precise0 r-cran-mass=7.3-33-1precise0 r-cran-matrix=1.1-3-1precise0 r-cran-mgcv=1.7-29-1precise0 r-cran-nlme=3.1.117-1precise0 r-cran-nnet=7.3-8-1precise0 r-cran-rpart=4.1-8-1precise0 r-cran-spatial=7.3-6-1precise0 r-cran-survival=2.37-7-1precise0 

# Set CRAN repository to use
RUN echo 'local({r <- getOption("repos"); r["CRAN"] <- "http://cran.r-project.org"; options(repos=r)})' > ~/.Rprofile

# Install bioconductor
RUN R -e 'source("http://bioconductor.org/biocLite.R"); biocLite("DESeq2"); install.packages("FactoMineR")'

# Cleanup
RUN apt-get clean

# Default command to execute at startup of the container
CMD R --no-save

# Install vim
RUN apt-get install --yes vim
