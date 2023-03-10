FROM python:3.6.4

RUN apt-get update && apt-get install --no-install-recommends -y gfortran python-openbabel python-vtk python3-tk && rm -rf /var/lib/apt/lists/*;
RUN wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -b
RUN export PATH=$HOME/miniconda3/bin:$PATH