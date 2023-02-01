FROM pydata:latest

RUN pip3 install --no-cache-dir git+git://github.com/Theano/Theano.git
RUN pip3 install --no-cache-dir git+https://github.com/fchollet/keras.git

EXPOSE 8888
