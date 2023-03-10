FROM jinaai/jina:1.2.1

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
RUN pip install --no-cache-dir pytest pytest-mock mock && pytest

ENTRYPOINT ["jina", "pod", "--uses", "config.yml", "--timeout-ready", "120000"]
