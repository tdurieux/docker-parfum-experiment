FROM nvidia/cuda:11.2.1-cudnn8-runtime

RUN apt update && apt install --no-install-recommends -y python3.8 python3-pip git && rm -rf /var/lib/apt/lists/*;
RUN JINA_PIP_INSTALL_PERF=1 pip install --no-cache-dir jina~=2.0

COPY gpu_requirements.txt gpu_requirements.txt
RUN pip install --no-cache-dir -r gpu_requirements.txt

COPY . /workdir/
WORKDIR /workdir

ENTRYPOINT ["jina", "executor", "--uses", "config.yml"]
