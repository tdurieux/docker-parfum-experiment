FROM python:3.9-slim

ENV TARGET_DIR /opt/darts-cnn-cifar10

ADD examples/v1beta1/trial-images/darts-cnn-cifar10 ${TARGET_DIR}
WORKDIR  ${TARGET_DIR}

RUN pip install --no-cache-dir -r requirements.txt
RUN chgrp -R 0 ${TARGET_DIR} \
  && chmod -R g+rwX ${TARGET_DIR}

ENTRYPOINT ["python3", "-u", "run_trial.py"]