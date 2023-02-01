FROM jinaai/jina:2-py37-perf

# install git
RUN apt-get update && apt-get install --no-install-recommends -y git && \
    apt-get -y --no-install-recommends install libgomp1 libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev && \
    rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/*;

# install requirements before copying the workspace
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# setup the workspace
COPY . /workdir
WORKDIR /workdir

ENTRYPOINT ["jina", "executor", "--uses", "config.yml"]
