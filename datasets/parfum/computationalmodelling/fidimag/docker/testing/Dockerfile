FROM ubuntu:20.04

# To build this image `docker build -t fidimag .`
# Then you can drop into a live bash shell with `docker run -it fidimag`.
ENTRYPOINT ["/bin/bash"]  
SHELL ["/bin/bash", "-c"] 

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y -qq
RUN apt-get install -y -qq  build-essential cmake cython3 python3-dev python3-pip \
    liblapack-dev libopenblas-dev \
    wget curl git

RUN pip3 install --upgrade setuptools
RUN pip3 install numpy matplotlib ipywidgets nbval pyvtk six psutil pytest pytest-cov pluggy scipy -U

WORKDIR /fidimag
ADD . /fidimag
RUN ./bin/install-sundials.sh
RUN ./bin/install-fftw.sh
RUN make build

ENV PYTHONPATH=/fidimag \
    LD_LIBRARY_PATH=/fidimag/local/lib LD_RUN_PATH=/fidimag/local/lib \
    OMP_NUM_THREADS=1 MPLBACKEND=Agg QT_API=pyqt


RUN make test-docker
RUN make ipynb-docker
