ARG BASEIMAGE=bladedisc:latest-devel-cpu-aarch64
FROM ${BASEIMAGE}

ARG WHEEL_FILE=blade_disc*.whl

ADD ./build/${WHEEL_FILE}  /install/python/
ADD ./build/disc-replay-main /usr/bin/disc-replay-main

RUN . /opt/venv_disc/bin/activate && \
    pip install --no-cache-dir /install/python/${WHEEL_FILE}
