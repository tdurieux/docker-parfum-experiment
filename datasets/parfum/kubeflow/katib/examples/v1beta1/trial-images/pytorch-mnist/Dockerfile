FROM python:3.9-slim

ADD examples/v1beta1/trial-images/pytorch-mnist /opt/pytorch-mnist
WORKDIR /opt/pytorch-mnist

# Add folder for the logs.
RUN mkdir /katib
RUN pip install --no-cache-dir -r requirements.txt

RUN chgrp -R 0 /opt/pytorch-mnist \
  && chmod -R g+rwX /opt/pytorch-mnist \
  && chgrp -R 0 /katib \
  && chmod -R g+rwX /katib

ENTRYPOINT ["python3", "/opt/pytorch-mnist/mnist.py"]
