FROM nvidia/cuda:10.2-runtime-ubuntu18.04


RUN apt update && apt install --no-install-recommends -y git python3.7 python3-pip \
    && cd /usr/local/bin \
    && ln -nsf /usr/bin/python3.7 python \
    && python -m pip install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

RUN JINA_PIP_INSTALL_PERF=1 pip --no-cache-dir install jina==2.0.20

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install Jina and third-party requirements
RUN pip install --no-cache-dir -r gpu_requirements.txt

ENTRYPOINT ["jina", "executor", "--uses", "config.yml"]