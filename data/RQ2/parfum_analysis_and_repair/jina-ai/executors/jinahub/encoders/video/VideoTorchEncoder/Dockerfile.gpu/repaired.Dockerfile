FROM jinaai/jina:2-py37-perf

# install git
RUN apt-get -y update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# install requirements before copying the workspace
COPY gpu_requirements.txt /gpu_requirements
RUN pip install --no-cache-dir -r gpu_requirements

# setup the workspace
COPY . /workspace
WORKDIR /workspace

ENTRYPOINT ["jina", "executor", "--uses", "config.yml"]
