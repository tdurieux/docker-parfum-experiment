FROM docker.deepsystems.io/supervisely/import/crops_and_weeds/base:v1.03

############### copy code ###############
ARG MODULE_PATH
ENV MODULE_PATH=$MODULE_PATH
ENV PUBLIC_PATH supervisely_lib

COPY ${MODULE_PATH}/src /workdir/src
COPY ${PUBLIC_PATH} /workdir/supervisely_lib

WORKDIR /workdir/src

ENV PYTHONPATH /workdir:$PYTHONPATH

ARG WORKER_PATH
ENV WORKER_PATH=$WORKER_PATH
RUN echo 'worker path = '${WORKER_PATH}

ENV LANG C.UTF-8
RUN pip install pydevd

ENTRYPOINT ["sh", "-c", "python -u ${WORKER_PATH}"]
