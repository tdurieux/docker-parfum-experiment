FROM tensorflow/tensorflow:latest-gpu
LABEL maintainer="code@adamltyson.com"
RUN pip install --no-cache-dir cellfinder
CMD ["bash"]
