FROM jinaai/jina:1.2.1

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN apt-get update && apt-get install --no-install-recommends -y gcc build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
RUN pip install --no-cache-dir pytest && pytest

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]
