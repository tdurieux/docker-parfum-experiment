FROM tensorflow/tensorflow:nightly-gpu

RUN apt-get update && apt-get install --no-install-recommends -y git vim && rm -rf /var/lib/apt/lists/*;

#download tensorflow models and sample training file                     
RUN git clone https://github.com/tensorflow/models.git
RUN python3 -m pip install --upgrade pip
ENV PYTHONPATH="$PYTHONPATH:/models"
RUN pip3 install --no-cache-dir -r /models/official/requirements.txt
RUN pip3 install --no-cache-dir torch==1.8.1 torchvision==0.9.1
# notebook for debug purpose
RUN pip3 install --no-cache-dir jupyter matplotlib
RUN pip3 install --no-cache-dir jupyter_http_over_ws ipykernel nbformat
RUN jupyter serverextension enable --py jupyter_http_over_ws
RUN pip3 install --no-cache-dir pynvml

RUN mkdir /tmp/{model,data,logs,scripts}
WORKDIR /tmp/scripts
COPY ./resnet-cifar10-tf2.py .
COPY ./resnet-cifar10-pytorch.py .
COPY ./resnet_imagenet.sh .
COPY ./data_dump.py .	
#CMD ["tail", "-f", "/dev/null"]

EXPOSE 8888
RUN python3 -m ipykernel.kernelspec
CMD ["bash", "-c", "jupyter notebook --notebook-dir=/tmp/scripts --ip 0.0.0.0 --port 8888 --no-browser --allow-root"]
