FROM rocker/rstudio:4.1.0

RUN apt-get update && \
        apt-get install -y --no-install-recommends \
        r-cran-rmarkdown r-cran-knitr && \
        Rscript -e 'utils::install.packages(c("intergraph", "igraphdata"))' && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends \
        libharfbuzz-dev libfribidi-dev \
        libssl-dev libxml2-dev libfontconfig1-dev libcurl4-openssl-dev \
        libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev && \
        Rscript -e 'utils::install.packages("pkgdown")' && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y --no-install-recommends r-cran-igraph && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends r-cran-covr r-cran-tinytest && rm -rf /var/lib/apt/lists/*;
RUN Rscript -e 'utils::install.packages(c("servr", "XML"))'

