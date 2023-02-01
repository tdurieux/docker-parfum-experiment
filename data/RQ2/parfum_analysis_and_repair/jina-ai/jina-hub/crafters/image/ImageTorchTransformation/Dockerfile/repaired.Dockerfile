FROM jinaai/jina AS base

# setup the workspace
COPY . /workspace
WORKDIR /workspace

# install the third-party requirements
RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

# for testing the image
FROM base
RUN pip install --no-cache-dir pytest && pytest

FROM base
ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]