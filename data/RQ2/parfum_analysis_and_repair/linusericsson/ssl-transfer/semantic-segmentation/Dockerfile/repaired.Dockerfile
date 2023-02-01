FROM pytorch/pytorch:0.4.1-cuda9-cudnn7-runtime
RUN apt-get update && apt-get -y --no-install-recommends install gcc && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --requirements git+https://github.com/CSAILVision/semantic-segmentation-pytorch.git
