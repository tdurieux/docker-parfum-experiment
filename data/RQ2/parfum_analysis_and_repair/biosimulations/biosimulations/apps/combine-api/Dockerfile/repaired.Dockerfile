#############
### base ###
#############
FROM python:3.9-buster as base

WORKDIR /app

###################################
# update apt package database
RUN apt-get update -y

###################################
# AMICI
RUN apt-get install --no-install-recommends -y \
        g++ \
        libatlas-base-dev \
        swig && rm -rf /var/lib/apt/lists/*;

###################################
# BioNetGen
ARG BIONETGEN_VERSION=2.8.0
RUN apt-get install -y --no-install-recommends \
        perl \
        tar \
        wget \
    \
    && cd /tmp \
    && wget https://github.com/RuleWorld/bionetgen/releases/download/BioNetGen-${BIONETGEN_VERSION}/BioNetGen-${BIONETGEN_VERSION}-linux.tgz \
    && tar xvvf BioNetGen-${BIONETGEN_VERSION}-linux.tgz \
    && mv BioNetGen-${BIONETGEN_VERSION}/ /opt/ \

    && rm BioNetGen-${BIONETGEN_VERSION}-linux.tgz && rm -rf /var/lib/apt/lists/*;
ENV PATH=${PATH}:/opt/BioNetGen-${BIONETGEN_VERSION}/

###################################
# BoolNet
ARG BOOLNET_VERSION=2.1.5
RUN apt-get install -y --no-install-recommends \
        r-base \
        build-essential \
        gcc \
        gfortran \
        libblas-dev \
        libcurl4-openssl-dev \
        libgit2-dev \
        liblapack-dev \
        libssl-dev \
        libxml2 \
        libxml2-dev \

    && Rscript \
        -e "install.packages('devtools')" \
        -e "require(devtools)" \
        -e "install_version('BoolNet', version='${BOOLNET_VERSION}')" \
        -e "require('BoolNet')" && rm -rf /var/lib/apt/lists/*;

###################################
# CBMPy
RUN apt-get install -y --no-install-recommends \
        gcc \
        libglpk-dev && rm -rf /var/lib/apt/lists/*;

###################################
# COBRAPY
RUN mkdir -p /.cache/cobrapy \
    && chmod ugo+rw /.cache/cobrapy

###################################
# COPASI

###################################
# GillesPy2
RUN apt-get install -y --no-install-recommends \
        build-essential && rm -rf /var/lib/apt/lists/*;

###################################
# GINsim: Set up path; needed up installation of GINsim Python package is fixed
RUN mkdir -p /usr/share/man/man1/ \
    && apt-get install -y --no-install-recommends \
        default-jre \
        wget \
    \
    && cd /tmp \
    && pip install --no-cache-dir ginsim \
    && wget https://raw.githubusercontent.com/GINsim/GINsim-python/master/ginsim_setup.py \
    && python ginsim_setup.py \

    && rm ginsim_setup.py && rm -rf /var/lib/apt/lists/*;

###################################
# libSBMLSIM
ARG LSBMLSIM_VERSION=1.4.0
ARG LIBSBML_VERSION=5.19.0

# libSBML
RUN apt-get install --no-install-recommends -y \
        wget \
        libxml2 \
    \
    && wget https://master.dl.sourceforge.net/project/sbml/libsbml/${LIBSBML_VERSION}/stable/Linux/64-bit/libSBML-${LIBSBML_VERSION}-Linux-x64.deb \
    && dpkg -i libSBML-${LIBSBML_VERSION}-Linux-x64.deb \

    && rm libSBML-${LIBSBML_VERSION}-Linux-x64.deb && rm -rf /var/lib/apt/lists/*;
ENV LD_LIBRARY_PATH=/usr/lib64:$LD_LIBRARY_PATH

# LibSBMLSim
RUN apt-get install --no-install-recommends -y \
        wget \
        build-essential \
        cmake \
        swig \
        libbz2-dev \
    \
    && PY_EXEC_PATH=$(which python) \
    && PY_PREFIX=$(echo ${PY_EXEC_PATH} | rev | cut -d "/" -f 3- | rev) \
    && cd /tmp \
    && wget https://github.com/libsbmlsim/libsbmlsim/archive/refs/tags/v${LSBMLSIM_VERSION}.tar.gz \
    && tar xvvf v${LSBMLSIM_VERSION}.tar.gz \
    && cd libsbmlsim-${LSBMLSIM_VERSION} \
    && mkdir build \
    && cd build \
    && PYTHON_MAJOR_MINOR_VERSION=$(echo $PYTHON_VERSION | cut -d . -f 1-2) \
    && cmake \
        -D LIBSBML_INCLUDE_DIR=/usr/include \
        -D LIBSBML_LIBRARY=/usr/lib64/libsbml.so \
        -D WITH_PYTHON=ON \
        -D PYTHON_PREFIX=${PY_PREFIX} \
        -D PYTHON_EXECUTABLE:FILEPATH=${PY_EXEC_PATH} \
        -D PYTHON_INCLUDE_DIR:PATH=/usr/local/include/python${PYTHON_MAJOR_MINOR_VERSION} \
        -D PYTHON_LIBRARY:FILEPATH=/usr/local/lib/libpython${PYTHON_MAJOR_MINOR_VERSION}.so \
        .. \
    \
    && make \
    && make install \
    \
    && cd /tmp \
    && rm v${LSBMLSIM_VERSION}.tar.gz \
    && rm -r libsbmlsim-${LSBMLSIM_VERSION} && rm -rf /var/lib/apt/lists/*;

###################################
# MASSpy
RUN apt-get install -y --no-install-recommends \
        git \
        gcc \
        build-essential \
        libfreetype6-dev \
        libfreetype6 \
        pkg-config \

    && mkdir -p /.cache/cobrapy && rm -rf /var/lib/apt/lists/*;

###################################
# NetPyNe
RUN apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    make \
    libmpich-dev \
    mpi \
    mpi-default-bin \
    mpich && rm -rf /var/lib/apt/lists/*;

###################################
# NEURON
RUN apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    make && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir neuron
ENV NEURON_HOME=/usr/local

###################################
# pyNeuroML, LEMS
RUN mkdir -p /usr/share/man/man1/ \
    && apt-get install -y --no-install-recommends \
        default-jre && rm -rf /var/lib/apt/lists/*;

###################################
# PySCeS

# SUNDIALS
# ignore certificate checking because certificate was expired as of 2021-11-10
ARG SUNDIALS_VERSION=2.6.2
RUN apt-get install -y --no-install-recommends \
        wget \
        cmake \
        make \
        g++ \
    \
    && cd /tmp \
    && wget --no-check-certificate https://computing.llnl.gov/sites/default/files/inline-files/sundials-${SUNDIALS_VERSION}.tar.gz \
    && tar xvvf sundials-${SUNDIALS_VERSION}.tar.gz \
    && cd sundials-${SUNDIALS_VERSION} \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    \
    && cd /tmp \
    && rm sundials-${SUNDIALS_VERSION}.tar.gz \
    && rm -r sundials-${SUNDIALS_VERSION} && rm -rf /var/lib/apt/lists/*;
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Assimulo
RUN apt-get install -y --no-install-recommends \
        g++ \
        gfortran \
        libblas-dev \
        liblapack-dev \
        git && rm -rf /var/lib/apt/lists/*;

# PySCeS
RUN apt-get install -y --no-install-recommends \
        git \
        gcc \
        gfortran \
        libgfortran5 && rm -rf /var/lib/apt/lists/*;

# Configure PySCeS
COPY Dockerfile-assets/.pys_usercfg.ini /Pysces/.pys_usercfg.ini
COPY Dockerfile-assets/.pys_usercfg.ini /root/Pysces/.pys_usercfg.ini
RUN mkdir -p /Pysces \
    && mkdir -p /Pysces/psc \
    && mkdir -p /root/Pysces \
    && mkdir -p /root/Pysces/psc \
    && chmod ugo+rw -R /Pysces

###################################
# RBApy
RUN apt-get install -y --no-install-recommends \
        gcc \
        libglpk-dev && rm -rf /var/lib/apt/lists/*;

###################################
# Smoldyn

###################################
# tellurium
RUN apt-get install -y --no-install-recommends \
        libxml2 \
        libncurses5 && rm -rf /var/lib/apt/lists/*;
ENV PLOTTING_ENGINE=matplotlib \
    PYTHONWARNINGS="ignore:The 'warn' parameter of use():UserWarning:tellurium.tellurium,ignore:Matplotlib is currently using agg:UserWarning:tellurium.plotting.engine_mpl"

###################################
# XPP
RUN apt-get install -y --no-install-recommends \
        wget \
        make \
        gcc \
        libx11-dev \
        libc6-dev \
        libx11-6 \
        libc6 \
    \
    && cd /tmp \
    && wget https://www.math.pitt.edu/~bard/bardware/xppaut_latest.tar.gz \
    && mkdir xpp \
    && tar zxvf xppaut_latest.tar.gz --directory xpp \
    && cd xpp \
    && make \
    && make install \

    && cd /tmp \
    && rm xppaut_latest.tar.gz \
    && rm -r xpp && rm -rf /var/lib/apt/lists/*;

###################################
# setup headless for NEURON, Smoldyn
RUN apt-get -y update \
    \
    && apt-get install --no-install-recommends -y \
        xvfb \
    && mkdir /tmp/.X11-unix \
    && chmod 1777 /tmp/.X11-unix \
    \
    && rm -rf /var/lib/apt/lists/*
COPY Dockerfile-assets/xvfb-startup.sh /xvfb-startup.sh
ENV XVFB_RES="1920x1080x24" \
    XVFB_ARGS=""

###################################
# fonts for matplotlib
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends libfreetype6 \
    && rm -rf /var/lib/apt/lists/*

# configure matplotlib cache and config to avoid warnings
RUN mkdir -p /.cache/matplotlib \
    && mkdir -p /.config/matplotlib \
    && chmod ugo+rw /.config/matplotlib \
    && chmod ugo+rw /.cache/matplotlib

# Configure default simulator options
ENV ALGORITHM_SUBSTITUTION_POLICY=SIMILAR_VARIABLES \
    VERBOSE=0 \
    MPLBACKEND=PDF \
    PLOTTING_ENGINE=matplotlib

###################################
# setup python, ports

# install pipenv
RUN pip install --no-cache-dir pipenv

# Copy over dependency list
COPY Dockerfile-assets/Pipfile /app/Pipfile
COPY Dockerfile-assets/Pipfile.lock /app/Pipfile.lock

# install environment
RUN pipenv install --system --deploy

# set up matplotlib font manager
RUN python -c "import matplotlib.font_manager"

# install assimulo because pipenv fails to install it
ARG ASSIMULO_VERSION=3.2.9
RUN pip install --no-cache-dir git+https://github.com/modelon-community/Assimulo.git@Assimulo-${ASSIMULO_VERSION}

EXPOSE 3333
CMD /bin/bash /xvfb-startup.sh \
    gunicorn \
        --bind 0.0.0.0:3333 src.app:app \
        --workers 2 \
        --threads 4 \
        --worker-class gthread \
        --max-requests 1000 \
        --timeout 30 \
        --keep-alive 5 \
        --worker-tmp-dir /dev/shm \
        --log-level debug \
        --log-file=-

#############
### build ###
#############
FROM base as build

ARG app
ENV APP=$app

RUN echo building ${app}

COPY src/ /app/src/
COPY vendor/ /app/vendor/
RUN python -m compileall /app/src/ \
    && PY_EXEC_PATH=$(which python) \
    && PY_PREFIX=$(echo ${PY_EXEC_PATH} | rev | cut -d "/" -f 3- | rev) \
    && PYTHON_MAJOR_MINOR_VERSION=$(echo $PYTHON_VERSION | cut -d . -f 1-2) \
    && python -m compileall ${PY_PREFIX}/lib/python${PYTHON_MAJOR_MINOR_VERSION}/site-packages \
    && PYTHONPATH=/app python -c "from src.handlers.run.utils import write_simulator_specs_cache; write_simulator_specs_cache();" \
    || exit 0

LABEL \
    org.opencontainers.image.title="BioSimulations ${app}" \
    org.opencontainers.image.description="Docker image for BioSimulations ${app}" \
    org.opencontainers.image.url="https://biosimulations.org/" \
    org.opencontainers.image.documentation="https://docs.biosimulations.org/" \
    org.opencontainers.image.source="https://github.com/biosimulations/biosimulations" \
    org.opencontainers.image.authors="BioSimulations Team <info@biosimulations.org>" \
    org.opencontainers.image.vendor="BioSimulations Team" \
    org.opencontainers.image.licenses="MIT"
