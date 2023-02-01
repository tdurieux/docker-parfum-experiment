FROM nvidia/cudagl:10.1-runtime
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install freeglut3-dev python3.7 python3-pip python3-opencv ffmpeg git libosmesa6-dev && rm -rf /var/lib/apt/lists/*;
RUN  mkdir -p /workspace/code/
RUN git clone https://github.com/jonepatr/FLAME_PyTorch.git /workspace/code/FLAME_PyTorch
WORKDIR /workspace
COPY code/visualize /workspace/code/visualize
COPY code/setup.py /workspace/code/setup.py
COPY code/misc /workspace/code/misc
COPY code/config.toml /workspace/code/config.toml
COPY code/config.local.toml /workspace/code/config.local.toml
RUN pip3 install --no-cache-dir -r /workspace/code/visualize/requirements.txt
CMD ["uvicorn", "--host", "0.0.0.0", "--app-dir", "/workspace/code/visualize", "render_server:app"]