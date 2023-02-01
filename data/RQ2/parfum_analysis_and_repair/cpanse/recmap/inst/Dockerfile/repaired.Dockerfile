FROM rocker/geospatial:4.0.3-daily
MAINTAINER Christian Panse <Christian.Panse@gmail.com>
RUN install2.r --error \ 
  GA \
  colorspace  \
  doParallel \
  knitr \
  maps \
  rcmdcheck \
  shiny \
  testthat
# RUN apt-get install texlive-fonts-extra -y
RUN apt-get update --fix-missing && apt-get install --no-install-recommends curl -y && cd /tmp \
 && curl -f -s https://codeload.github.com/cpanse/recmap/zip/master \
 > recmap.zip && unzip recmap.zip \
 && R CMD build recmap-master --no-build-vignettes \
 && R CMD check recmap_*.tar.gz --no-manual --no-build-vignettes \
 && R CMD INSTALL recmap*.gz && rm -rf /var/lib/apt/lists/*;
