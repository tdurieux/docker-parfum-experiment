FROM jinaai/jina AS base

# Setup the workspace
COPY . /workspace
WORKDIR /workspace

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Run tests
FROM base
RUN pip install --no-cache-dir pytest && pytest

# Run encoder as pod
FROM base
ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]
