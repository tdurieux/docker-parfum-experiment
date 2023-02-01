From at-docker:5000/pipeline:base

LABEL maintainer="Erick Cobos <ecobos@bcm.edu>, Donnie Kim <donniek@bcm.edu>"

# Install pip3
RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

# Uninstall CPU version tensorflow and install GPU version
RUN pip3 uninstall -y tensorflow && \
    pip3 install --no-cache-dir tensorflow-gpu==1.13.1

WORKDIR /data

# Install commons
RUN git clone https://github.com/atlab/commons.git && \
    pip3 install --no-cache-dir commons/python && \
    rm -r commons

# Install pipeline
RUN git clone https://github.com/cajal/pipeline.git && \
    pip3 install --no-cache-dir -e pipeline/python

ENTRYPOINT ["/bin/bash"]
