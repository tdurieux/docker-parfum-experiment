FROM rocker/verse:4.0.2

MAINTAINER "David OK" <david.ok8@gmail.com>

# To avoid console interaction with apt.
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /workspace
COPY . .

RUN apt-get update -y -qq && apt-get install --no-install-recommends -y -qq python3 python3-pip librsvg2-bin && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir matplotlib numpy sympy

RUN Rscript -e 'devtools::install_cran(c( \
      "berryFunctions", \
      "gifski", \
      "remotes", \
      "reticulate", \
      "Rcpp", "RcppEigen",\
      "tinytex"\
      ))'
RUN Rscript -e 'tinytex::install_tinytex()'

# RUN Rscript -e "bookdown::render_book('index.Rmd', 'all', output_dir = 'public')"
