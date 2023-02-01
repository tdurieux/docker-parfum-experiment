FROM gcr.io/deeplearning-platform-release/tf-cpu.1-15

WORKDIR /neogpt

# Make RUN commands use `bash --login`:
SHELL ["/bin/bash", "--login", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install --no-install-recommends tmux -y && rm -rf /var/lib/apt/lists/*;
RUN conda install gcc_linux-64 gxx_linux-64 -y
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get install --no-install-recommends screen htop -y && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install tensorboard==1.15 cloud_tpu_profiler==1.15

CMD tmux