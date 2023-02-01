FROM jinaai/jina:1.3.0

# setup the workspace
COPY . /workspace
WORKDIR /workspace

RUN apt-get update && \
    apt-get install --no-install-recommends -y gcc\
                                               python-dev && rm -rf /var/lib/apt/lists/*;

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
RUN pip install --no-cache-dir pytest pytest-mock mock && JINA_TEST_PRETRAINED='true' pytest

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]
