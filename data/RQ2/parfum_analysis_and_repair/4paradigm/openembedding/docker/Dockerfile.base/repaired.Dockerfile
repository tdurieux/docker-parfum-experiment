# to use glibc 2.12 and dt7 which have the same system compatibility as tensorflow
FROM tensorflow/tensorflow:2.3.0-custom-op-ubuntu16

RUN cd /dt7/usr/bin && ln -s gcc cc && cd /

# use glibc 2.12