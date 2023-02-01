FROM ubuntu:latest
LABEL version="0.0"
LABEL description="This is a test Ubuntu build for trying to install nglpy."
RUN apt-get -y update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --index-url https://test.pypi.org/simple/ nglpy
