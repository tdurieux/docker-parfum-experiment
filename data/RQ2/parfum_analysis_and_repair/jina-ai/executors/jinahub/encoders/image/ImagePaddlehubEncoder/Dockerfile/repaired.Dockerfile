FROM jinaai/jina:2-py37-perf

# install git
RUN apt-get -y update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git libgomp1 libglib2.0-0 libsm6 libxext6 libfontconfig1 libxrender1 && rm -rf /var/lib/apt/lists/*;

# install requirements before copying the workspace
COPY requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# setup the workspace
COPY . /workspace
WORKDIR /workspace

ENTRYPOINT ["jina", "executor", "--uses", "config.yml"]