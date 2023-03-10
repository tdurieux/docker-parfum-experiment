FROM caffe2ai/caffe2:latest
MAINTAINER Aaron Markham <aaronmarkham@fb.com>

# Caffe2 source refresh and tutorial files overlay
# Change to a CPU-only docker base if needed (latest is GPU)

########## INSTALLATION STEPS ###################
RUN apt-get install unzip vim -y --no-install-recommends && rm -rf /var/lib/apt/lists/*;
WORKDIR "/"
RUN rm -rf caffe2
RUN git clone --recursive https://github.com/caffe2/caffe2.git

########## REBUILD ###################
WORKDIR "/caffe2"
RUN make
WORKDIR "/caffe2/build"
RUN make install
ENV PYTHONPATH /usr/local
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH
WORKDIR "/usr/local"

########## SETUP TUTORIAL FILES #################
# get model files for Loading Pre-Trained Models
RUN python -m caffe2.python.models.download -i squeezenet
# not installing these by default to keep the image smaller
# RUN python -m caffe2.python.models.download -i bvlc_alexnet
# RUN python -m caffe2.python.models.download -i bvlc_googlenet
# RUN python -m caffe2.python.models.download -i bvlc_reference_caffenet
# rcnn model throws error, so holding off until fixed
# RUN python -m caffe2.python.models.download -i bvlc_reference_rcnn_ilsvrc13
# RUN python -m caffe2.python.models.download -i finetune_flickr_style
# get MNIST dataset for MNIST
WORKDIR "/caffe2/caffe2/python/tutorials"
RUN mkdir tutorial_data && cd tutorial_data
WORKDIR "/caffe2/caffe2/python/tutorials/tutorial_data"
RUN wget "https://download.caffe2.ai/datasets/mnist/mnist.zip"
RUN unzip -d mnist mnist.zip
WORKDIR "/caffe2/caffe2/python/tutorials"
