FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y make python python-pip git && rm -rf /var/lib/apt/lists/*;
COPY tests/safety/requirements.txt /panda/tests/safety/requirements.txt
RUN pip install --no-cache-dir -r /panda/tests/safety/requirements.txt
COPY . /panda
