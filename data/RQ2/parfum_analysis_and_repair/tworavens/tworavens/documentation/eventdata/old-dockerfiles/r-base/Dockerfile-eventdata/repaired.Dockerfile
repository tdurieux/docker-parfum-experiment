FROM tworavens/r-service-base:last-zelig
MAINTAINER Raman Prasad (raman_prasad@harvard.edu)

LABEL organization="Two Ravens" \
      2ra.vn.version="0.0.7-beta" \
      2ra.vn.release-date="2018-07-03" \
      description="Image for the base of the Two Ravens R service. (event data specific)"


# ----------------------------------------------------
# Mongolite dependency
# ----------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libsasl2-dev && rm -rf /var/lib/apt/lists/*;

# ----------------------------------------------------
# This contains R packages for eventdata
# ----------------------------------------------------
RUN  R -e 'install.packages("cellranger", repos="http://cran.rstudio.org")' && \
     R -e 'install.packages("mongolite", repos="http://cran.rstudio.org")'

EXPOSE 8000
