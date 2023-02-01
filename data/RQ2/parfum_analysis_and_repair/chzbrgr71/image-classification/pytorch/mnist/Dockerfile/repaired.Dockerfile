FROM pytorch/pytorch:1.0-cuda10.0-cudnn7-runtime

RUN pip install --no-cache-dir tensorboardX==1.6.0
WORKDIR /var
ADD mnist.py /var

ENTRYPOINT ["python", "/var/mnist.py"]
