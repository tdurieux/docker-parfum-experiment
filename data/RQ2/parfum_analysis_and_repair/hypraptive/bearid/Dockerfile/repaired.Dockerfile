FROM python:3.7-slim AS bearid-build

RUN apt-get -y update \
  && apt-get install --no-install-recommends -y build-essential cmake \
  && apt-get install --no-install-recommends -y wget \
  && rm -rf /var/lib/apt/lists/*

# for opencv
# RUN apt-get install -y libopencv-dev
# BLAS
RUN apt-get -y update && apt-get install --no-install-recommends -y libopenblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;

# Boost
RUN wget -q https://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.tar.bz2 \
  && mkdir -p /usr/share/boost && tar jxf boost_1_58_0.tar.bz2 -C /usr/share/boost --strip-components=1 \
  && ln -s /usr/share/boost/boost /usr/include/boost && rm boost_1_58_0.tar.bz2
RUN apt-get -y update && apt-get install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;

# X11 dev
RUN apt-get -y update && apt-get install --no-install-recommends -y libx11-dev && rm -rf /var/lib/apt/lists/*;

# dlib 19.7 (http://dlib.net/files/dlib-19.7.tar.bz2)
RUN wget -q https://dlib.net/files/dlib-19.7.tar.bz2 \
  && tar -xjf dlib-19.7.tar.bz2 && rm dlib-19.7.tar.bz2

# build and install imglab
RUN cd dlib-19.7/tools/imglab \
    && mkdir build \
    && cd build \
    && cmake .. \
    && cmake --build . --config Release \
    && make install

# bearid
RUN apt-get -y update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/hypraptive/bearid.git \
  && cd bearid \
  && mkdir build \
  && cd build \
  && cmake -DDLIB_PATH=/dlib-19.7 .. \
  && cmake --build . --config Release

# bearid-models
RUN cd / \
  && git clone https://github.com/hypraptive/bearid-models.git
#  && mv bearid-models/*.dat . \
#  && cp ../bearid.py .

# RUN
FROM python:3.7-slim
RUN apt-get -y update && apt-get install --no-install-recommends -y libx11-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y update && apt-get install --no-install-recommends -y libopenblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y update && apt-get install --no-install-recommends -y libboost-filesystem1.67.0 && rm -rf /var/lib/apt/lists/*;
COPY --from=bearid-build /bearid/build/bear* /
COPY --from=bearid-build /bearid/bearid.py /
COPY --from=bearid-build /usr/local/bin/imglab /usr/local/bin/imglab
COPY --from=bearid-build /bearid-models/*.dat /

WORKDIR /
# CMD ["python","bearid.py","/home/data/bears/imageSourceSmall/images"]
CMD python bearid.py /home/data/bears/imageSourceSmall/images && sed -i 's;/home/data/bears/imageSourceSmall/images/;;' ./result/imgs_faces_chips_embeds_svm.xml && mv ./result/imgs_faces_chips_embeds_svm.xml /home/data/bears/imageSourceSmall/images
