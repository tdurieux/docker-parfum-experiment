FROM jinaai/jina:2-py37-perf

RUN apt-get -y update && apt-get install --no-install-recommends -y git gcc ffmpeg libsm6 libxext6 && rm -rf /var/lib/apt/lists/*;

# install requirements before copying the workspace
COPY requirements.txt /requirements.txt
RUN pip install -r requirements.txt --no-cache-dir

# setup the workspace
COPY . /workspace
WORKDIR /workspace

ENTRYPOINT ["jina", "executor", "--uses", "config.yml"]
