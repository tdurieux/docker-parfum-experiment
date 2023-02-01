# Dockerfile for package buliding and running this package
FROM rocker/r-ver:4.0.2

RUN apt-get update && apt-get -y --no-install-recommends install \
  texlive-latex-base \
  texlive-fonts-extra \
  texinfo \
  libcurl4-gnutls-dev && rm -rf /var/lib/apt/lists/*;

RUN R -e "install.packages('remotes')"

COPY DESCRIPTION /home/docker/individual/

RUN R -e "library('remotes'); install_deps('/home/docker/individual', dependencies = TRUE)"
