FROM fkrull/multi-python:bionic
WORKDIR /code
COPY . /code/
RUN export LC_ALL=C.UTF-8 && \
    export LANG=C.UTF-8 && \
    pip3 install --no-cache-dir . && \
    pip3 install --no-cache-dir tox==3.23.0 && \
    tox