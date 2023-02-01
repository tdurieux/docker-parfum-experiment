FROM continuumio/miniconda3:4.8.2

# Install procps so that Nextflow can poll CPU usage
RUN apt-get update && apt-get install --no-install-recommends -y procps && apt-get clean -y && rm -rf /var/lib/apt/lists/*;

#install transdecoder
RUN conda install -c bioconda transdecoder
