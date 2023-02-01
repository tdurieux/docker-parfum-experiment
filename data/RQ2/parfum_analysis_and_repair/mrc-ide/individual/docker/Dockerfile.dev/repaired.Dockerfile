# Dockerfile with development tools for:
# easy testing, documentation generation and benchmarking
FROM rocker/r-ver:4.0.2

RUN apt-get update && apt-get -y --no-install-recommends install \
  texlive-latex-base \
  texlive-fonts-extra \
  texinfo \
  libcurl4-gnutls-dev \
  libssl-dev \
  libxml2-dev \
  libgit2-dev \
  pandoc \
  time \
  valgrind \
  gdb && rm -rf /var/lib/apt/lists/*;

RUN R -e "install.packages(c('devtools', 'roxygen2', 'testthat', 'pkgdown'))"

COPY DESCRIPTION /tmp/DESCRIPTION

RUN R -e "library('remotes'); install_deps('/tmp', dependencies = TRUE)"
