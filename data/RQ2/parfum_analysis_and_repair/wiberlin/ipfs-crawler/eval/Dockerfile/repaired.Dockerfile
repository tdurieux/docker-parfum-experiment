############################################################
# Dockerfile to run the evaluation of the IPFS-crawler
############################################################

FROM ubuntu:18.04

LABEL maintainer="sebastian.henningsen@hu-berlin.de"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q && apt-get install --no-install-recommends -qy \
	texlive-full \
	latexmk \
	r-base \
	python3-pip && rm -rf /var/lib/apt/lists/*;
RUN Rscript -e "install.packages(c(\"data.table\", \"reshape2\", \"ggplot2\", \"scales\", \
             \"tikzDevice\", \"stringr\", \"pbapply\", \"igraph\", \"xtable\", \"tidyr\", \"jsonlite\"), repos=\"http://cran.us.r-project.org\")"

RUN pip3 install --no-cache-dir geoip2 numpy IP2Location

COPY . /eval
WORKDIR /eval

RUN mkdir /output_data_crawls

VOLUME ["/output_data_crawls", "/eval/plot_data/", "eval/figures", "eval/tables"]

CMD make all