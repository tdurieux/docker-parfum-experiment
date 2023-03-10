## Emacs, make this -*- mode: sh; -*-

FROM ubuntu:focal

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rocker-org/r-apt" \
      org.label-schema.vendor="Rocker Project" \
      maintainer="Dirk Eddelbuettel <edd@debian.org>"

## Set a default user. Available via runtime flag `--user docker`
## Add user to 'staff' group, granting them write privileges to /usr/local/lib/R/site.library
## User should also have & own a home directory (for rstudio or linked volumes to work properly).
RUN useradd docker \
	&& mkdir /home/docker \
	&& chown docker:docker /home/docker \
	&& addgroup docker staff

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		software-properties-common \
                ed \
		less \
		locales \
		vim-tiny \
		wget \
		ca-certificates \
                dirmngr \
                gpg-agent \
        && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && rm -rf /var/lib/apt/lists/*;

## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8 \
        && echo "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" > /etc/apt/sources.list.d/cran.list

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

## This was not needed before but we need it now
ENV DEBIAN_FRONTEND noninteractive

# Now install R and littler, and create a link for littler in /usr/local/bin
# Default CRAN repo is now set by R itself, and littler knows about it too
# r-cran-docopt is not currently in c2d4u so we install from source
RUN apt-get update \
        && apt-get install -y --no-install-recommends \
 		 r-base \
 		 r-base-dev \
 		 r-recommended \
                 r-cran-littler \
	&& ln -s /usr/lib/R/site-library/littler/examples/build.r /usr/local/bin/build.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/check.r /usr/local/bin/check.r \
  	&& ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
	&& ln -s /usr/lib/R/site-library/littler/examples/installBioc.r /usr/local/bin/installBioc.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
 	&& ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/local/bin/testInstalled.r \
 	&& rm -rf /var/lib/apt/lists/* \
        && chgrp 1000 /usr/local/lib/R/site-library

COPY Rprofile.site /etc/R

## Install "some" libraries we are likely to need to run-time:
##   libgdal26     (package sf)
##   libgeos-3.8.0 (package sf)
##   libproj15     (package sf)
##   libudunits2-0 (package units, sf)
##   libxml2       (package xml2, tidyverse)
## and install docopt used by some of the littler scripts
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
                   libgdal26 \
                   libgeos-3.8.0 \
                   libproj15 \
                   libudunits2-0 \
		   libxml2 \
	&& install.r docopt \
 	&& rm -rf /tmp/downloaded_packages/* /tmp/*.rds \
        && chmod a+w /tmp/downloaded_packages && rm -rf /var/lib/apt/lists/*;

CMD ["bash"]
