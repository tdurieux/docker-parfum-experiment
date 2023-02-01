FROM jinaai/jina:1.2.1 as base

# setup the workspace
COPY . /workspace
WORKDIR /workspace

RUN apt-get update && \
    apt-get -y --no-install-recommends install libgomp1 libgl1-mesa-glx libglib2.0-0 libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt && pip uninstall -y pathlib

# for testing the image
FROM base
RUN pip install --no-cache-dir pytest pytest-mock mock && pytest -v -s

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]
