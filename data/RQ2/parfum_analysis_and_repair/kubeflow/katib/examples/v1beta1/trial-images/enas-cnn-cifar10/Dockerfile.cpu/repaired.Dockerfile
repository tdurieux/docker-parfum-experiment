FROM python:3.9-slim

ENV TARGET_DIR /opt/enas-cnn-cifar10

ADD examples/v1beta1/trial-images/enas-cnn-cifar10 ${TARGET_DIR}
WORKDIR  ${TARGET_DIR}

ENV PYTHONPATH ${TARGET_DIR}

RUN if [ "$(uname -m)" = "aarch64" ]; then \
    apt-get -y update && \
    apt-get -y --no-install-recommends install gfortran libpcre3 libpcre3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*; \
    fi

RUN pip install --no-cache-dir -r requirements.txt
RUN chgrp -R 0 ${TARGET_DIR} \
  && chmod -R g+rwX ${TARGET_DIR}

ENTRYPOINT ["python3", "-u", "RunTrial.py"]
