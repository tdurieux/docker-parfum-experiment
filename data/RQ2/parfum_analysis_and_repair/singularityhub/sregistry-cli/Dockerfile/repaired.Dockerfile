FROM quay.io/singularity/singularity:v3.10.0-slim

#########################################
# Singularity Registry Global Client
#
# docker build -t quay.io/vanessa/sregistry-cli .
# docker run quay.io/vanessa/sregistry-cli
#########################################

RUN apk update && apk add --no-cache python3-dev python3 py3-pip g++
RUN pip3 install --no-cache-dir dateutils

RUN mkdir /code
ADD . /code
RUN pip3 install --no-cache-dir setuptools && pip3 install --no-cache-dir scif
RUN scif install /code/sregistry-cli.scif
ENTRYPOINT ["sregistry"]

WORKDIR /code
RUN pip3 install --no-cache-dir -e .[all]
