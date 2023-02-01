FROM nvcr.io/nvidia/deepstream-l4t:5.1-21.02-samples

RUN apt-get update && apt install --no-install-recommends python3-gi python3-dev python3-gst-1.0 python3-numpy python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends gir1.2-gst-rtsp-server-1.0 -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade google-api-python-client

VOLUME  /repo
WORKDIR /repo/deepstream/5.1

ENTRYPOINT ["bash", "deepstream-51-jetson.bash"]
