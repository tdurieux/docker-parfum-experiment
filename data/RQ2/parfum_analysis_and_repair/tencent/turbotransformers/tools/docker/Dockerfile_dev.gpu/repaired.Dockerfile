FROM IMAGE_BASE

# RUN sed -i s@/archive.ubuntu.com/@/mirrors.tuna.tsinghua.edu.cn/@g /etc/apt/sources.list && apt-get update && \
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl git ninja-build && rm -rf /var/lib/apt/lists/*

ENV PATH=/opt/miniconda3/bin:${PATH} CONDA_PREFIX=/opt/miniconda3

# RUN curl -LO https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh && \
RUN curl -f -LO https://repo.anaconda.com/miniconda/Miniconda3-py37_4.8.3-Linux-x86_64.sh && \
    bash Miniconda3-py37_4.8.3-Linux-x86_64.sh -p /opt/miniconda3 -b && \
    rm Miniconda3-py37_4.8.3-Linux-x86_64.sh && \
    conda install pytorch=PYTORCH_VERSION cudatoolkit=CUDA_VERSION cudnn -c pytorch -y && \
    conda install conda-verify conda-build mkl-include cmake ninja -c anaconda -y && \
    conda clean -afy

RUN pip install --no-cache-dir OpenNMT-py==1.2.0 docopt onnxruntime-gpu==1.3.0

# build turbo
RUN mkdir -p /src && cd /src && git clone https://github.com/Tencent/TurboTransformers.git --recursive && cd ./TurboTransformers && \
    sh ./tools/build_and_run_unittests.sh $PWD -DWITH_GPU=ON

WORKDIR /workspace
