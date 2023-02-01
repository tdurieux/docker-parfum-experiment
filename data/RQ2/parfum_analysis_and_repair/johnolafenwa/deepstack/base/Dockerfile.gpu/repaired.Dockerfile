FROM deepquestai/deepstack-base:cuda

RUN apt-get install --no-install-recommends libsm6 libxext6 libxrender1 libglib2.0-0 ffmpeg -y && rm -rf /var/lib/apt/lists/*;

