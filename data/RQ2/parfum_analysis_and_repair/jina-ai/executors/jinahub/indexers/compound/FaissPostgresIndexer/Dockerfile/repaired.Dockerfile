FROM jinaai/jina:2-py37-perf as base

# install and upgrade pip
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# setup the workspace
COPY requirements.txt /requirements.txt

# install Jina and third-party requirements
RUN python3.7 -m pip install -r requirements.txt

COPY . /workspace
WORKDIR /workspace

FROM base as entrypoint
ENTRYPOINT ["jina", "executor", "--uses", "config.yml"]
