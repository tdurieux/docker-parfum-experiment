ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN deps=''\
  && apt-get update\
  # for route and sudo
  && apt-get install --no-install-recommends -y curl gosu net-tools sudo ${deps}\
  && apt-get purge -y --auto-remove ${deps} \
  && pip3 install --no-cache-dir cffi minio bottle && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /sebs
COPY docker/local/run.sh /sebs/
COPY docker/local/*.py /sebs/
COPY docker/local/python/*.py /sebs/
COPY docker/local/python/run_server.sh /sebs/
COPY docker/local/python/timeit.sh /sebs/
COPY docker/local/python/runners.json /sebs/
ADD third-party/pypapi/pypapi /sebs/pypapi
ENV PYTHONPATH=/sebs/.python_packages/lib/site-packages:$PYTHONPATH

COPY docker/local/entrypoint.sh /sebs/entrypoint.sh
RUN chmod +x /sebs/entrypoint.sh
RUN chmod +x /sebs/run.sh

ENTRYPOINT ["/sebs/entrypoint.sh"]
