FROM bazel/reproducible:ubuntu_vanilla
RUN apt-get update -y && \
    apt-get install --no-install-recommends -y -q \
      python-pip \
      python-dev && \
      apt-get clean && \
    rm /var/lib/apt/lists/*_*
RUN pip install --no-cache-dir setuptools
RUN pip install --no-cache-dir google-cloud==0.32.0
