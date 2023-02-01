ARG BASE_CONTAINER=marsproject/mars-base
FROM ${BASE_CONTAINER}

RUN /srv/retry.sh 3 /opt/conda/bin/conda install -c pkgs/main \
    coverage\>=5.0 cloudpickle \
  && conda clean --all -f -y

RUN apt-get -yq update --allow-releaseinfo-change && apt-get -yq --no-install-recommends install git gcc g++ && rm -rf /var/lib/apt/lists/*;

COPY docker-logging.conf /srv/logging.conf
COPY build_ext.sh /srv/build_ext.sh
COPY entrypoint.sh /srv/entrypoint.sh
COPY graceful_stop.sh /srv/graceful_stop.sh

RUN echo "import coverage; coverage.process_startup()" > \
    $(/opt/conda/bin/python -c "import site; print(site.getsitepackages()[-1])")/coverage.pth
RUN chmod a+x /srv/*.sh
