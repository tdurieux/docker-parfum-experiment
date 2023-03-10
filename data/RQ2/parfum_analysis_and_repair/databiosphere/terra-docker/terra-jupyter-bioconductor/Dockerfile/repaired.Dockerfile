FROM us.gcr.io/broad-dsp-gcr-public/terra-jupyter-r:2.1.5

USER root

## Install Bioconductor Core packages
RUN curl -f -O https://raw.githubusercontent.com/Bioconductor/anvil-docker/master/anvil-rstudio-bioconductor/install.R \
	&& R -f install.R \
	&& rm -rf install.R

USER $USER
