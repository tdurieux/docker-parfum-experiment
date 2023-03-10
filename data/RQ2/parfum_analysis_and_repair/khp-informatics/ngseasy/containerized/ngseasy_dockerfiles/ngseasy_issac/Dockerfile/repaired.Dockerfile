# Base image
FROM compbio/ngseasy-base:1.0-r001
# Maintainer
MAINTAINER Stephen Newhouse stephen.j.newhouse@gmail.com

RUN apt-get install --no-install-recommends -y gnuplot libnuma-dev libz-dev markdown zlib1g-dev doxygen && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/local/pipeline && \
    git clone --recursive https://github.com/sequencing/isaac_aligner.git && \
    mkdir ISSAC && \
    /usr/local/pipeline/isaac_aligner/src/configure --prefix=/usr/local/pipeline/ISSAC && \
    make && \
    make install

RUN cd /usr/local/pipeline && \
    wget https://github.com/sequencing/isaac_variant_caller/archive/v1.0.7.tar.gz && \
    tar -xvf v1.0.7.tar.gz && \

#Cleanup the temp dir
RUN rm -rf /tmp/* && rm v1.0.7.tar.gz

#open ports private only
EXPOSE 8080

# Use baseimage-docker's bash.
CMD ["/bin/bash"]

#Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN apt-get autoclean && apt-get autoremove -y && rm -rf /var/lib/{apt,dpkg,cache,log}/
