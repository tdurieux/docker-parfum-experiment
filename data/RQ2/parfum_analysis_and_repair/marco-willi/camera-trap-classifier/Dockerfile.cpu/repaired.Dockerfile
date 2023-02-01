FROM tensorflow/tensorflow:1.12.0-py3

RUN apt-get --yes update && apt-get --yes --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir git+git://github.com/marco-willi/camera-trap-classifier

ENTRYPOINT ["bash"]
