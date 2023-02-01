FROM tensorflow/tensorflow:2.9.1-gpu

ENV TARGET_DIR /opt/enas-cnn-cifar10

ADD examples/v1beta1/trial-images/enas-cnn-cifar10 ${TARGET_DIR}
WORKDIR  ${TARGET_DIR}

ENV PYTHONPATH ${TARGET_DIR}

RUN pip install --no-cache-dir scipy==1.8.1
RUN chgrp -R 0 ${TARGET_DIR} \
  && chmod -R g+rwX ${TARGET_DIR}

ENTRYPOINT ["python3", "-u", "RunTrial.py"]