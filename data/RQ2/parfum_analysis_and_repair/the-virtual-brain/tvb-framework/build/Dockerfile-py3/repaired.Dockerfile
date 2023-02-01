FROM continuumio/miniconda3

RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install postgresql && rm -rf /var/lib/apt/lists/*;

USER postgres
RUN service postgresql start && createdb -O postgres tvb-test && psql --command "ALTER USER postgres WITH PASSWORD 'postgres';"

USER root
RUN conda update -n base -c defaults conda

RUN conda create -y --name tvb-run python=3.7 nomkl numba scipy numpy networkx scikit-learn cython pip numexpr psutil
RUN conda install -y --name tvb-run pytest pytest-cov pytest-benchmark matplotlib
RUN conda install -y --name tvb-run psycopg2 pytables scikit-image==0.14.2 simplejson cherrypy docutils
RUN conda install -y --name tvb-run -c conda-forge jupyterlab

RUN /opt/conda/envs/tvb-run/bin/pip install --upgrade pip
RUN /opt/conda/envs/tvb-run/bin/pip install h5py>=2.10 formencode cfflib genshi nibabel sqlalchemy==1.1.14 sqlalchemy-migrate==0.11.0 allensdk BeautifulSoup4 subprocess32
RUN /opt/conda/envs/tvb-run/bin/pip install tvb-gdist tvb-data typing

RUN git clone --depth 1 https://github.com/the-virtual-brain/tvb-library.git;\
    cd tvb-library; git pull origin neotraits_py3; \
    /opt/conda/envs/tvb-run/bin/python setup.py develop

# -v [local- tvb-framework - clone]:/root/tvb-framework
CMD ["bash","-c","cd /root/tvb-framework && source activate tvb-run && pytest tvb/tests"]