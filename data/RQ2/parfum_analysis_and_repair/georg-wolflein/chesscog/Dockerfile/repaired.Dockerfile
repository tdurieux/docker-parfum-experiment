FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

# Install Python 3.8
RUN apt update && \
    apt install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt update && \
    apt install --no-install-recommends -y python3.8 python3-pip && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1 && rm -rf /var/lib/apt/lists/*;

# OpenGL is needed for OpenCV
RUN apt install --no-install-recommends -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

# Install zip
RUN apt install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

# Install poetry
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false

# Install dependencies
RUN mkdir -p /chess
WORKDIR /chess
COPY ./pyproject.toml ./poetry.lock* ./
RUN poetry install --no-root
ENV PYTHONPATH "/chess:${PYTHONPATH}"

# Setup data mount
RUN mkdir -p /data
ENV DATA_DIR /data
VOLUME /data

# Setup config mount
RUN mkdir -p /config
ENV CONFIG_DIR /config
VOLUME /config

# Setup run mount
RUN mkdir -p /chess/runs
ENV RUN_DIR /chess/runs
VOLUME /chess/runs

# Setup results mount
RUN mkdir -p /chess/results
ENV RESULTS_DIR /chess/results
VOLUME /chess/results

# Setup models mount
RUN mkdir -p /chess/models
ENV MODELS_DIR /chess/models
VOLUME /chess/models

# Copy files
COPY chesscog ./chesscog

# Scratch volume
VOLUME /chess/scratch

# Weird fix for poetry in the GPU container (not required for CPU)
RUN python3 -m pip install idna

# Entrypoint (password is "chesscog")
CMD poetry run tensorboard --logdir ./runs --host 0.0.0.0 --port 9999  & \
    poetry run jupyter lab --no-browser --allow-root --ip 0.0.0.0 --port 8888 --NotebookApp.password "sha1:22fda334b4b5:770a9d781f1e689afdcd2c55e7abae94ba74d925"