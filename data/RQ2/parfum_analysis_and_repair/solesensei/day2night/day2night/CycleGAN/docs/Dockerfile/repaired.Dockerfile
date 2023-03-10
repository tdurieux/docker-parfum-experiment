FROM nvidia/cuda:9.0-base

RUN apt update && apt install --no-install-recommends -y wget unzip curl bzip2 git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -LO http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda3 -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH=/miniconda3/bin:${PATH}
RUN conda update -y conda

RUN conda install -y pytorch torchvision -c pytorch
RUN mkdir /workspace/ && cd /workspace/ && git clone https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix.git && cd pytorch-CycleGAN-and-pix2pix && pip install --no-cache-dir -r requirements.txt

WORKDIR /workspace