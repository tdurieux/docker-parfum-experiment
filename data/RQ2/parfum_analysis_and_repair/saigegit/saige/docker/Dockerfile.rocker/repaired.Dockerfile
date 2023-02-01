FROM rocker/tidyverse:4.1.3

WORKDIR /app
COPY . .

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    python3-pip && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir cget

RUN Rscript extdata/install_packages.R

RUN R CMD INSTALL .
ENTRYPOINT ["/bin/bash"]
