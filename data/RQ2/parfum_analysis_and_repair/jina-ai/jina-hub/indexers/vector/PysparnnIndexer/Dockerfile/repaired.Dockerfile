FROM jinaai/jina:1.1.6 as base

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements

RUN apt-get update && apt-get install --no-install-recommends -y git && pip install --no-cache-dir git+https://github.com/facebookresearch/pysparnn.git && pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

# for testing the image
FROM base
RUN pip install --no-cache-dir pytest && pytest -v -s

FROM base
ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]