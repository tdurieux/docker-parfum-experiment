FROM jinaai/jina:1.2.1

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN apt-get update && apt-get install --no-install-recommends -y git curl && \
    pip install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

# for downloading pre-trained model
RUN bash download.sh

# for testing the image
RUN pip install --no-cache-dir pytest && pytest -v

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]