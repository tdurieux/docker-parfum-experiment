FROM jinaai/jina:1.2.1

# install git
RUN apt-get -y update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN pip install --no-cache-dir git+https://github.com/openai/CLIP.git

# for testing the image
RUN pip install --no-cache-dir pytest && pytest -s -vv

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]
