FROM jinaai/jina:1.2.1

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# for testing the image
RUN pip install --no-cache-dir pytest pytest-repeat && pytest

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]