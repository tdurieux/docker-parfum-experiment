from jupyter/datascience-notebook:latest

# copy things needed for the tutorial
# # images
#COPY analytics-toolkit-tutorials/example-data/face-of-crystals/ /home/beaker/.beaker/v1/web/

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y swig && rm -rf /var/lib/apt/lists/*;

# Install condor with dependencies
RUN cd /root/Sources && git clone https://github.com/FilipeMaia/libspimage.git && cd libspimage && mkdir build && cd build && cmake .. && make && make install
RUN cd /root/Sources && git clone https://github.com/FilipeMaia/spsim.git && cd spsim && mkdir build && cd build && cmake .. && make && make install
RUN cd /root/Sources && git clone https://github.com/mhantke/condor.git && cd condor && python setup.py install

# remove current version tensorflow and install 0.9.0
#RUN pip uninstall -y protobuf
#RUN pip uninstall -y tensorflow
#ENV TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.9.0-cp27-none-linux_x86_64.whl
#RUN pip install --upgrade $TF_BINARY_URL

# remove current Keras and install 1.2.0
#RUN rm -rf /usr/local/lib/python2.7/dist-packages/keras/
#RUN pip install --upgrade keras==1.2.0

# change default keras backend to Theano
RUN mkdir /home/beaker/.keras
COPY keras_tf.json /home/beaker/.keras/keras.json

# other pip dependencies
#RUN pip install pyshtools
#RUN pip install pyquaternion
#RUN pip install keras-tqdm

