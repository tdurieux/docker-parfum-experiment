FROM nvidia/cuda:11.4.2-runtime-ubuntu20.04

# install ubuntu dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y --no-install-recommends install python3-pip xvfb ffmpeg git build-essential python-opengl && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/python3 /usr/bin/python

# install python dependencies
RUN mkdir cleanrl_utils && touch cleanrl_utils/__init__.py
RUN pip install --no-cache-dir poetry
COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock
RUN poetry install
RUN poetry install -E atari
RUN poetry install -E pybullet

# install mujoco
RUN apt-get -y --no-install-recommends install wget unzip software-properties-common \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev patchelf && rm -rf /var/lib/apt/lists/*;
RUN poetry install -E mujoco
RUN poetry run python -c "import mujoco_py"

COPY entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# copy local files
COPY ./cleanrl /cleanrl
