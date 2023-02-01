FROM rocker/r-base

RUN apt-get update && apt-get install -y --no-install-recommends apt-utils dialog

RUN apt-get update -y && apt-get install -y bison \
  flex \
  libglib2.0-dev \
  libpcre3 \
  libpcre3-dev \
  libncurses5-dev \
  libncursesw5-dev \ 
  libcurl4-openssl-dev \
  libssl-dev

#  libssh2-1 \
#  libssh2-1-dev

RUN Rscript -e 'install.packages(pkgs = c("RUnit", "devtools", "plyr", "tm"))'
RUN Rscript -e 'install.packages("rcqp")'
RUN Rscript -e 'install.packages("polmineR")'
