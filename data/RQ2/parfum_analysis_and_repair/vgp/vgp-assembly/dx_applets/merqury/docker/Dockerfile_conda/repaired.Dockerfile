FROM continuumio/miniconda

LABEL com.dnanexus.tool="merqury"

RUN conda install -c conda-forge -c bioconda -y merqury