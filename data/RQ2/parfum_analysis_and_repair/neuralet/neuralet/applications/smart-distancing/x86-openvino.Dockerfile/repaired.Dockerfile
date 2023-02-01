FROM openvino/ubuntu18_runtime

USER root
VOLUME  /repo
WORKDIR /repo/applications/smart-distancing

RUN apt-get update && apt-get install --no-install-recommends -y pkg-config libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip setuptools==41.0.0 && pip3 install --no-cache-dir opencv-python wget flask scipy image

EXPOSE 8000

CMD source /opt/intel/openvino/bin/setupvars.sh && python3 neuralet-distancing.py --config=config-x86-openvino.ini

