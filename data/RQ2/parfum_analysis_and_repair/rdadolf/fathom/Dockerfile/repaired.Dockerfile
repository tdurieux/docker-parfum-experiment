FROM tensorflow/tensorflow:0.8.0rc0-devel
MAINTAINER Bob Adolf <rdadolf@gmail.com>

RUN apt-get update

### Software required for Fathom
RUN apt-get install --no-install-recommends -y python-scipy && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir scikit-learn
RUN pip install --no-cache-dir librosa
RUN apt-get install --no-install-recommends -y libhdf5-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir h5py

# ALE
RUN apt-get install --no-install-recommends -y libsdl1.2-dev libsdl-gfx1.2-dev libsdl-image1.2-dev cmake && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/mgbellemare/Arcade-Learning-Environment.git /tmp/ALE
RUN mkdir /tmp/build && cd /tmp/build && \
    cmake -DUSE_SDL=ON -DUSE_RLGLUE=OFF /tmp/ALE && make
RUN cd /tmp/ALE && pip install --no-cache-dir .
# OpenCV
RUN apt-get install --no-install-recommends -y libopencv-dev python-opencv && rm -rf /var/lib/apt/lists/*;

### Create a Fathom working environment
RUN mkdir /data
RUN useradd -ms /bin/bash fathom
RUN chown fathom /data
RUN chmod a+rwx /data
USER fathom
WORKDIR /home/fathom
RUN git clone https://github.com/rdadolf/fathom.git
ENV PYTHONPATH /home/fathom/fathom

