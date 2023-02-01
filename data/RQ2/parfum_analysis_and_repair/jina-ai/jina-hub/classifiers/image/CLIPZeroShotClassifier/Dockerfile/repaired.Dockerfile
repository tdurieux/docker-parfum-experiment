FROM pytorch/pytorch:1.7.1-cuda11.0-cudnn8-runtime as base

# install git
RUN apt-get -y update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN pip install --no-cache-dir git+https://github.com/openai/CLIP.git && \
    pip install --no-cache-dir -r requirements.txt

# for testing the image
FROM base
RUN pip install --no-cache-dir pytest && pytest

FROM base
ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]