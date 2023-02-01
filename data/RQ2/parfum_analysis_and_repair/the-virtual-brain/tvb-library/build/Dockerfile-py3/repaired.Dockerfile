FROM continuumio/miniconda3

RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential gcc && rm -rf /var/lib/apt/lists/*;

RUN conda update -n base -c defaults conda

RUN conda create -y --name tvb-run python=3.7 nomkl scipy numpy networkx scikit-learn cython pip numexpr psutil
RUN conda install -y --name tvb-run pytest pytest-cov h5py
RUN conda install -y --name tvb-run -c anaconda jupyter
RUN conda install -y --name tvb-run pytables numba scikit-image
RUN /opt/conda/envs/tvb-run/bin/pip install --upgrade pip
RUN /opt/conda/envs/tvb-run/bin/pip install subprocess32
RUN /opt/conda/envs/tvb-run/bin/pip install matplotlib
RUN /opt/conda/envs/tvb-run/bin/pip install tvb-data
RUN /opt/conda/envs/tvb-run/bin/pip install tvb-gdist
RUN /opt/conda/envs/tvb-run/bin/pip install pytest-benchmark

# -v [local- tvb-library - clone]:/root/tvb-library
CMD ["bash","-c","cd /root/tvb-library && source activate tvb-run && pytest tvb/tests"]