LABEL name="bilby Base Enterprise Linux 7" \
maintainer="Gregory Ashton <gregory.ashton@ligo.org>" \
date="20190104"

ENV PATH /opt/conda/bin:$PATH

# Install backend
RUN apt-get update --fix-missing \
&& apt-get install --no-install-recommends -y libglib2.0-0 libxext6 libsm6 libxrender1 libgl1-mesa-glx \
dh-autoreconf build-essential libarchive-dev wget curl git libhdf5-serial-dev && rm -rf /var/lib/apt/lists/*;

# Install python3.7
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
/bin/bash ~/miniconda.sh -b -p /opt/conda && \
rm ~/miniconda.sh && \
/opt/conda/bin/conda clean -tipsy && \
ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
echo "conda activate base" >> ~/.bashrc

# Update pip and setuptools
RUN pip install --no-cache-dir --upgrade pip \
&& LC_ALL=C pip --no-cache-dir install --upgrade setuptools

# Install conda-installable programs
RUN conda install -y numpy scipy matplotlib pandas

# Install conda-forge-installable programs
RUN conda install -c conda-forge deepdish arviz

# Install requirements
RUN pip install --no-cache-dir future \
pycondor >=0.5 \
configargparse \
flake8 \
mock \
pipenv \
coverage \
pytest-cov \
coverage-badge

# Install documentation requirements
RUN pip install --no-cache-dir sphinx numpydoc nbsphinx sphinx_rtd_theme sphinx-tabs

# Install additional bilby requirements
RUN pip install --no-cache-dir corner lalsuite astropy gwpy theano healpy tables

# Install samplers
RUN pip install --no-cache-dir cpnest dynesty emcee nestle ptemcee pymc3 pymultinest kombine ultranest dnest4

# Install pymultinest requirements
RUN apt-get install --no-install-recommends -y libblas3 libblas-dev liblapack3 liblapack-dev \
libatlas3-base libatlas-base-dev cmake build-essential gfortran && rm -rf /var/lib/apt/lists/*;

# Install pymultinest
RUN git clone https://github.com/farhanferoz/MultiNest.git \
&& (cd MultiNest/MultiNest_v3.11_CMake/multinest && mkdir build && cd build && cmake .. && make)

ENV LD_LIBRARY_PATH $HOME/MultiNest/MultiNest_v3.11_CMake/multinest/lib:

# Install Polychord
RUN git clone https://github.com/PolyChord/PolyChordLite.git \
&& (cd PolyChordLite && python setup.py --no-mpi install)

# Install PTMCMCSampler
RUN git clone https://github.com/jellis18/PTMCMCSampler.git \
&& (cd PTMCMCSampler && python setup.py install)

# Add the ROQ data to the image
RUN mkdir roq_basis \
    && cd roq_basis \
    && wget https://git.ligo.org/lscsoft/ROQ_data/raw/master/IMRPhenomPv2/4s/B_linear.npy \
    && wget https://git.ligo.org/lscsoft/ROQ_data/raw/master/IMRPhenomPv2/4s/B_quadratic.npy \
    && wget https://git.ligo.org/lscsoft/ROQ_data/raw/master/IMRPhenomPv2/4s/fnodes_linear.npy \
    && wget https://git.ligo.org/lscsoft/ROQ_data/raw/master/IMRPhenomPv2/4s/fnodes_quadratic.npy \
    && wget https://git.ligo.org/lscsoft/ROQ_data/raw/master/IMRPhenomPv2/4s/params.dat \
