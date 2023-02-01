FROM jinaai/jina:1.2.1 as base

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
FROM base
RUN pip install --no-cache-dir pytest && pytest

FROM base
ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]
