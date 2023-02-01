FROM pyda-python2.7

RUN pip install --no-cache-dir git+git://github.com/Theano/Theano.git
RUN pip install --no-cache-dir git+https://github.com/fchollet/keras.git

EXPOSE 8888
