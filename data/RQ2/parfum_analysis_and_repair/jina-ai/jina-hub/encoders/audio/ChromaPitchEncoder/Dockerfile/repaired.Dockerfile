FROM jinaai/jina:1.2.1

# setup the workspace
COPY . /workspace
WORKDIR /workspace


RUN apt-get update && \
    apt-get install --no-install-recommends -y libsndfile1 && rm -rf /var/lib/apt/lists/*;

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
RUN pip install --no-cache-dir pytest && pytest

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]