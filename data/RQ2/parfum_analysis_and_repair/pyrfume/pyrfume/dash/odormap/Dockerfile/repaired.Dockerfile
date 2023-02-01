FROM tiangolo/uwsgi-nginx-flask:python3.7
LABEL maintainer="maintainer"

##### Miniconda installation #####
RUN apt-get -qq update && apt-get -qq --no-install-recommends -y install curl bzip2 \
    && curl -f -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3 \
    && conda update conda \
    && apt-get -qq -y remove curl bzip2 \
    && apt-get -qq -y autoremove \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /var/log/dpkg.log \
    && conda clean --all --yes

ENV PATH /opt/conda/bin:$PATH

##### Conda packages #####
RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir pyrfume

#### Dash stuff ####
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
COPY app /app

ENV NGINX_WORKER_PROCESSES auto