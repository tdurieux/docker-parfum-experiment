FROM jinaai/jina:1.2.1

# setup the workspace
COPY . /workspace

WORKDIR /workspace

# install the third-party requirements
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get -y --no-install-recommends install redis-server && rm -rf /var/lib/apt/lists/*;

# for testing the image
RUN redis-server --bind 0.0.0.0 --port 6379:6379 --daemonize yes && pip install --no-cache-dir pytest && pip install --no-cache-dir pytest-mock && pytest

ENTRYPOINT ["jina", "pod", "--uses", "config.yml"]