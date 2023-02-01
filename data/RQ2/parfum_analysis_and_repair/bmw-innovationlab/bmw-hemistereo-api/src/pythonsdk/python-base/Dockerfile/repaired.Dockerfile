from python:slim

RUN apt update && apt install --no-install-recommends -y python3-pip git && apt clean && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir setuptools
RUN pip3 install --no-cache-dir grpcio-tools
RUN pip3 install --no-cache-dir twine
