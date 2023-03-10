FROM continuumio/miniconda3:latest
MAINTAINER Chris Harris <chris.harris@kitware.com>
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install tomopy
RUN conda install -c conda-forge tomopy

COPY tomviz/python/ /tmp/python/

RUN pip install --no-cache-dir /tmp/python/ && \
  rm -rf /tmp/python/

ENTRYPOINT ["tomviz-pipeline"]

ARG BUILD_DATE
ARG IMAGE=tomviz-tomopy-pipeline
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.description="Image containing python environment (with tomopy) to run Tomviz pipelines." \
      org.label-schema.url="https://github.com/OpenChemistry/tomviz" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"
