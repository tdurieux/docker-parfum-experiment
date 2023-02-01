# Distro
FROM jupyter/scipy-notebook

LABEL maintainer="Hazen Babcock <hbabcock@mac.com>"

USER root

RUN apt update
RUN apt-get --yes --no-install-recommends install gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install libfftw3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install libgeos-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install liblapack-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get --yes --no-install-recommends install scons && rm -rf /var/lib/apt/lists/*;

USER $NB_UID

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pillow
RUN pip install --no-cache-dir tifffile
RUN pip install --no-cache-dir shapely
RUN pip install --no-cache-dir pytest
RUN pip install --no-cache-dir astropy
RUN pip install --no-cache-dir randomcolor

# Get current storm-analysis
RUN mkdir code
WORKDIR code
RUN git clone https://github.com/ZhuangLab/storm-analysis.git

# Set working directory
WORKDIR storm-analysis

# run scons to build the C libraries.
RUN scons

# install storm-analysis.
RUN /bin/bash -c "python setup.py install;"

# copy storm-analysis jupyter notebooks to the work directory.
RUN mkdir ../../work/sa_notebooks
RUN cp jupyter_notebooks/* ../../work/sa_notebooks/.

# create local mount point
RUN mkdir ../../work/share

# record when this image was made
RUN date > ../../work/image_date.txt
RUN git rev-parse HEAD > ../../work/sa_version.txt

RUN fix-permissions $CONDA_DIR
RUN fix-permissions /home/$NB_USER

# start in home directory.
WORKDIR /home/$NB_USER/work

USER $NB_UID


