FROM jinaai/jina:1.3.0

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# for testing the image
RUN pip install --no-cache-dir pytest && pytest

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]