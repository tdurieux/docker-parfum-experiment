ARG BASEIMAGE=bladedisc:latest-devel-cpu-aarch64
FROM ${BASEIMAGE}

ARG WHEEL_FILE=torch_blade*.whl

ADD ./build/${WHEEL_FILE}  /install/python/

RUN . /opt/venv_disc/bin/activate && \
    pip install --no-cache-dir /install/python/${WHEEL_FILE}
