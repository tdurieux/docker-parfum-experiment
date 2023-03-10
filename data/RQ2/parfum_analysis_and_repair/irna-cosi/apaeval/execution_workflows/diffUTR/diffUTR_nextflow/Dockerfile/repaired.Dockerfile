################## BASE IMAGE ######################
FROM rocker/r-ubuntu:20.04


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install --no-install-recommends --no-install-suggests \
        ca-certificates software-properties-common gnupg2 gnupg1 \
      && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
      && add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/' \
      && apt-get install --no-install-recommends r-base -y && rm -rf /var/lib/apt/lists/*;

# Install required libraries -- using prebuild binaries where available
RUN apt-get update && apt-get install --no-install-recommends -y \
aptitude \
libcurl4-openssl-dev \
libxml2-dev \
libcairo2-dev \
libssl-dev \
git \
r-cran-devtools \
r-cran-git2r \
r-cran-xml \
r-cran-cairo \
r-cran-rcurl \
sudo && rm -rf /var/lib/apt/lists/*;

# Install
RUN installGithub.r ETHZ-INS/diffUTR \
&& rm -rf /tmp/downloaded_packages/

RUN Rscript -e 'install.packages("BiocManager", repos = "http://cran.us.r-project.org")'
RUN Rscript -e 'BiocManager::install(c("Cairo" ,"diffUTR"), ask=FALSE, update = FALSE)'
