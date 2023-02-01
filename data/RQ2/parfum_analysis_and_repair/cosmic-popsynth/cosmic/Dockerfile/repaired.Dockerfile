FROM ubuntu:groovy-20210225 AS spython-base
RUN apt-get -y update && apt-get -y --no-install-recommends install libopenmpi-dev openmpi-bin libhdf5-serial-dev cmake git python3-mpi4py python3-pip python3-numpy && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/COSMIC-PopSynth/COSMIC.git /COSMIC
RUN cd /COSMIC
RUN pip3 install --no-cache-dir /COSMIC
CMD /usr/bin/cosmic-pop
