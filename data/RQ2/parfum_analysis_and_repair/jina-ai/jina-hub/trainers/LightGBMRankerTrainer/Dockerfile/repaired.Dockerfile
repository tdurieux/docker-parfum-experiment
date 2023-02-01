FROM jinaai/jina:1.2.3 as base

RUN apt-get update && apt-get install -y --no-install-recommends libgomp1 && rm -rf /var/lib/apt/lists/*;

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
FROM base
RUN pip install --no-cache-dir pytest && pytest -s -v

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]
