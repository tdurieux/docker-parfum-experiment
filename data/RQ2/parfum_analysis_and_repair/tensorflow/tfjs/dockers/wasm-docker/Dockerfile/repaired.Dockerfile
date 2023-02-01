# Official emsdk docker: https://hub.docker.com/r/emscripten/emsdk
FROM emscripten/emsdk:2.0.14

# Install yarn
RUN npm install -g yarn && npm cache clean --force;

RUN apt-get update -qqy && apt-get install --no-install-recommends -qqy \
        gcc \
        python3 \
        python3-pip \
        python \
        python-pip \
        file && rm -rf /var/lib/apt/lists/*;

# Install absl
RUN pip3 install --no-cache-dir -U absl-py
