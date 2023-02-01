FROM stimela/base:1.2.5
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 10
RUN apt-get update
RUN pip3 install --no-cache-dir -U pip setuptools \
    pyyaml \
    python-casacore
RUN pip install --no-cache-dir numba==0.48
RUN pip install --no-cache-dir scabha
RUN pip install --no-cache-dir -I ragavi
RUN ragavi-gains -h
RUN ragavi-vis -h
RUN ragavi-vis -v