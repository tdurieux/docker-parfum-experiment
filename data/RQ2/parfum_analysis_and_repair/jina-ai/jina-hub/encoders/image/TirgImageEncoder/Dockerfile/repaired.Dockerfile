FROM jinaai/jina:1.2.1

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# Get model and texts file
RUN apt-get -y update \
    && apt-get -y --no-install-recommends install wget \
    && wget -O checkpoint.pth https://storage.googleapis.com/image_retrieval_css/pretrained_models/checkpoint_fashion200k.pth \
    && wget https://github.com/bwanglzu/tirg/raw/main/texts.pkl && rm -rf /var/lib/apt/lists/*;

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt

# for testing the image
RUN pip install --no-cache-dir pytest && pytest -s -vv

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]
