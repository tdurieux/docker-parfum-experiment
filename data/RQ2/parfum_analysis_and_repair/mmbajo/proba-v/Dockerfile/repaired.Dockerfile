FROM tensorflow/tensorflow:latest-gpu-py3-jupyter

WORKDIR /tf
ADD /. /tf
RUN pip install --no-cache-dir -r requirements.txt

