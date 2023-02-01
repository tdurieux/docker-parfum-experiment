FROM python:3.6-jessie

LABEL maintainer="Report Bee <www.reportbee.com>"


RUN apt-get update
# Pick up some TF dependencies
RUN apt-get install -y software-properties-common
RUN apt-get install -y curl
RUN apt-get install -y unzip
RUN apt-get install -y build-essential
RUN apt-get install -y libfreetype6-dev
RUN apt-get install -y libhdf5-serial-dev
RUN apt-get install -y libpng-dev
RUN apt-get install -y libzmq3-dev
RUN apt-get install -y pkg-config
RUN apt-get install -y vim
RUN apt-get install wget
RUN apt-get -y install python3-pip

#OPENCV dependencies
# https://stackoverflow.com/questions/47113029/importerror-libsm-so-6-cannot-open-shared-object-file-no-such-file-or-directo
RUN apt-get install -y libsm6 libxext6
RUN apt-get install -y libfontconfig1 libxrender1

RUN pip3 install Pillow
RUN pip3 install h5py 
RUN pip3 install ipykernel
RUN pip3 install jupyter 
RUN pip3 install matplotlib 
#Fix numpy to 1.13.3
RUN pip3 install numpy==1.13.3 
RUN pip3 install pandas 
RUN pip3 install scipy 
RUN pip3 install sklearn 
RUN pip3 install keras
RUN pip3 install opencv-python
RUN pip3 install scikit-image
RUN pip3 install tensorflow==1.7.0
RUN python3 -m ipykernel.kernelspec

# For Jupyter notebook
EXPOSE 8888
#For TensorBoard
EXPOSE 6006

WORKDIR ~/app

#Setup Tensorflow object detection
RUN git clone https://github.com/tensorflow/models.git

# RUN apt-get install -y protobuf-compiler
RUN pip3 install Cython
RUN pip3 install lxml

# https://github.com/tensorflow/models/issues/4002
# Installing Protobuf
RUN curl -OL https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip
RUN unzip protoc-3.2.0-linux-x86_64.zip -d protoc3
RUN mv protoc3/bin/* /usr/local/bin/
RUN mv protoc3/include/* /usr/local/include/
RUN rm protoc-3.2.0-linux-x86_64.zip
RUN rm -rf protoc3

# RUN cd models/research
# RUN protoc ./models/research/object_detection/protos/*.proto --python_out=.
RUN cd models/research && protoc ./object_detection/protos/*.proto --python_out=.

# # From tensorflow/models/research/
RUN echo 'export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim' >> ~/.bashrc

RUN jupyter notebook --generate-config

COPY ./app/jupyter-notebook-config.py /root/.jupyter/jupyter_notebook_config.py

ENV PASSWORD reportbee

CMD ["jupyter", "notebook", "--allow-root"]
