FROM stimela/base:1.6.0
RUN docker-apt-install gfortran libboost-python-dev libboost-numpy-dev
RUN pip install --no-cache-dir pip -U
RUN pip install --no-cache-dir numpy scipy
RUN pip install --no-cache-dir astropy astro-tigger-lsm git+https://github.com/lofar-astron/PyBDSF
