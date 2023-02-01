FROM underworldcode/underworld2:dev
MAINTAINER romain.beucher@unimelb.edu

USER root
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        python-tk

# UWGeodynamics
WORKDIR /opt
RUN git clone -b development https://github.com/underworldcode/UWGeodynamics.git
RUN pip3 install -e /opt/UWGeodynamics

# Badlands dependency
RUN pip3 install pandas
RUN pip3 install ez_setup
RUN pip3 install git+https://github.com/badlands-model/triangle.git
RUN pip3 install git+https://github.com/awickert/gFlex.git

# pyBadlands serial
WORKDIR /opt
RUN git clone https://github.com/rbeucher/pyBadlands_serial.git
# Remove gzip compression...HDF5 is installed via PETSC and zlib is not found
RUN cd /opt/pyBadlands_serial/pyBadlands && \
    find . -iname "*.py" -type f -print0 | xargs -0 sed -i "s/, compression='gzip'//g"
RUN pip3 install -e pyBadlands_serial/
WORKDIR /opt/pyBadlands_serial/pyBadlands/libUtils
RUN make
RUN pip3 install -e /opt/pyBadlands_serial

# pyBadlands dependencies
# RUN pip install cmocean
RUN git clone https://github.com/matplotlib/cmocean.git /tmp/cmocean && \
    pip3 install /tmp/cmocean/ && \ 
    rm -rf /tmp/cmocean
RUN pip3 install colorlover
# Force matplotlib 2.1.2 (Bug Badlands), Temporary
RUN pip3 install matplotlib==2.1.2

ENV PATH $PATH:/opt/pyBadlands_serial/pyBadlands/libUtils
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/pyBadlands_serial/pyBadlands/libUtils

