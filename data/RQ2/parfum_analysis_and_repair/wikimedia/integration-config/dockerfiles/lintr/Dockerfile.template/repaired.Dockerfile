FROM {{ "ci-buster" | image_tag }}

# The r language itself and dependencies to build lintr

{% set builddeps|replace('\n', ' ') -%}
make
gcc
g++
gfortran
liblapack-dev
libcurl4-openssl-dev
{%- endset -%}

{% set rundeps|replace('\n', ' ') -%}
libxml2-dev
libssl-dev
r-cran-devtools
r-cran-git2r
r-cran-usethis
{%- endset -%}

{% set alldeps = builddeps + " " + rundeps -%}

RUN  {{ "r-base" | apt_install }}
RUN  {{ alldeps | apt_install }}
RUN Rscript -e 'devtools::install_github("jimhester/lintr@v1.0.3")' && \
    apt-get purge --yes {{ builddeps }} && \
    apt-get autoremove --yes --purge

USER nobody
WORKDIR /src
ENTRYPOINT /bin/bash /run.sh
COPY run.sh /run.sh
COPY lint.R /lint.R