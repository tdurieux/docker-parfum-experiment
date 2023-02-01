FROM nvcr.io/nvidia/deepstream:5.1-21.02-triton

RUN apt-get update && apt install --no-install-recommends python3-gi python3-dev python3-gst-1.0 python3-numpy -y && rm -rf /var/lib/apt/lists/*;

VOLUME  /repo
WORKDIR /repo/deepstream/5.1

ENTRYPOINT ["bash", "deepstream-51-x86.bash"]
