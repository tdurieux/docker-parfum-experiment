# For lint test
FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y python-pip sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y doxygen graphviz && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir cpplint pylint
