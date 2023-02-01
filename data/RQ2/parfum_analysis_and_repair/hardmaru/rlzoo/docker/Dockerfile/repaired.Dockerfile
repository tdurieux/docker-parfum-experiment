ARG PARENT_IMAGE
ARG USE_GPU
FROM $PARENT_IMAGE

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
    ffmpeg \
    freeglut3-dev \
    swig \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV CODE_DIR /root/code
ENV VENV /root/venv

RUN \
    mkdir -p ${CODE_DIR}/rl_zoo && \
    . $VENV/bin/activate && \
    pip uninstall -y stable-baselines && \
    pip install --no-cache-dir stable-baselines[mpi]==2.10.0 && \
    pip install --no-cache-dir box2d-py==2.3.5 && \
    pip install --no-cache-dir pybullet && \
    pip install --no-cache-dir gym-minigrid && \
    pip install --no-cache-dir scikit-optimize && \
    pip install --no-cache-dir optuna && \
    pip install --no-cache-dir pytablewriter && \
    rm -rf $HOME/.cache/pip

ENV PATH=$VENV/bin:$PATH

COPY docker/entrypoint.sh /tmp/
ENTRYPOINT ["/tmp/entrypoint.sh"]

CMD /bin/bash
