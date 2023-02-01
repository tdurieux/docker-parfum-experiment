FROM tensorflow/tensorflow:latest-py3

VOLUME  /repo
WORKDIR /repo/applications/smart-distancing

RUN apt-get update && apt-get install --no-install-recommends -y pkg-config libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip setuptools==41.0.0 && pip install --no-cache-dir opencv-python wget flask scipy image

EXPOSE 8000

ENTRYPOINT ["python", "neuralet-distancing.py"]
CMD ["--config", "config-x86.ini"]
