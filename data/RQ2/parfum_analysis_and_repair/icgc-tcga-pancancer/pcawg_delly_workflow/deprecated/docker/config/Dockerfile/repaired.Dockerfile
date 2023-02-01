############################################################
# Dockerfile to build DELLY workflow container
# Based on Ubuntu
############################################################

# Set the base image to Ubuntu
FROM ubuntu

# File Author / Maintainer
MAINTAINER Ivica Letunic

RUN apt-get -m update

RUN apt-get install --no-install-recommends -y tar git curl nano wget dialog net-tools build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python python-dev python-distribute python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y r-base r-base-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tabix && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libdata-uuid-perl libjson-perl libxml-xpath-perl libxml-dom-perl libxml-libxml-perl && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir pybedtools
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir docopt
RUN pip install --no-cache-dir PyVCF
RUN pip install --no-cache-dir samtools
RUN echo "source(\"http://bioconductor.org/biocLite.R\")" > /tmp/dnacopy; echo "biocLite()" >> /tmp/dnacopy; R CMD BATCH /tmp/dnacopy
#RUN echo "biocLite()" >> /tmp/dnacopy
#RUN R CMD BATCH /tmp/dnacopy
RUN curl -f https://smart.embl.de/delly_bin.tar | tar xv -C /usr/bin/
RUN mkdir /work
