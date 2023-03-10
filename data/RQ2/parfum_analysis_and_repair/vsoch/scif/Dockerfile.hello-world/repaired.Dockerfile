# SciF Example
#
# docker build -f Dockerfile.hello-world -t quay.io/scif/scif:hw .
# docker run quay.io/scif/scif:hw
# docker push quay.io/scif/scif:hw

FROM continuumio/miniconda3

#######################################
# SciF Install
#######################################

# Can be replaced with pip install scif
RUN mkdir /code
ADD . /code
RUN python /code/setup.py install
ENV PATH=/opt/conda/bin:$PATH

#######################################
# SciF Entrypoint
#######################################