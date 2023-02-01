FROM jinaai/jina:2-py37-perf

RUN apt update && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
COPY gpu_requirements.txt gpu_requirements.txt
RUN pip install --no-cache-dir -r gpu_requirements.txt

COPY . /workdir/
WORKDIR /workdir

ENTRYPOINT ["jina", "executor", "--uses", "config.yml"]
