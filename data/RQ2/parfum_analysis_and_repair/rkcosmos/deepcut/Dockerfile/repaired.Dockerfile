FROM tensorflow/tensorflow:2.0.0-py3

RUN apt-get install --no-install-recommends -y git \
     && pip install --no-cache-dir --upgrade pip \
     && pip install --no-cache-dir git+https://github.com/rkcosmos/deepcut.git && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT /bin/bash
