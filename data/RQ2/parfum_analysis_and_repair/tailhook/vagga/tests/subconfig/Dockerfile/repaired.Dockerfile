FROM ubuntu:focal
RUN apt-get update && apt-get install --no-install-recommends -y \

    python pip && rm -rf /var/lib/apt/lists/*;
# Some comment, just to ensure that it will be ignored
RUN pip install --no-cache-dir setuptools urp
