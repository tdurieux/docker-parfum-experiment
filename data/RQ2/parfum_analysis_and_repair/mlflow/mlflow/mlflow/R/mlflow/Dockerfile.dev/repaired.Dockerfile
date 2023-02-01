FROM rocker/r-ver:latest

WORKDIR /mlflow/mlflow/R/mlflow
RUN apt-get update -y && apt-get install --no-install-recommends git wget libxml2-dev libgit2-dev -y && rm -rf /var/lib/apt/lists/*;
# pandoc installed by `apt-get` is too old and contains a bug.
RUN TEMP_DEB=$(mktemp) && \
    wget --directory-prefix $TEMP_DEB https://github.com/jgm/pandoc/releases/download/2.16.2/pandoc-2.16.2-1-amd64.deb && \
    dpkg --install $(find $TEMP_DEB -name '*.deb') && \
    rm -rf $TEMP_DEB
COPY DESCRIPTION .
COPY .install-deps.R .
RUN Rscript -e 'source(".install-deps.R", echo = TRUE)'
