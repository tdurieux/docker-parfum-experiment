FROM nuveo/opencv:alpine-python2-base

ENV OPENCV_VERSION=3.3.0

# Install OpenCV
RUN mkdir /opt && cd /opt && \
    wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
    unzip ${OPENCV_VERSION}.zip && \
    rm -rf ${OPENCV_VERSION}.zip && \
    mkdir -p /opt/opencv-${OPENCV_VERSION}/build && \
    cd /opt/opencv-${OPENCV_VERSION}/build && \
    cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_FFMPEG=NO \
    -D WITH_IPP=NO \
    -D WITH_OPENEXR=NO \
    -D WITH_TBB=YES \
    -D BUILD_EXAMPLES=NO \
    -D BUILD_ANDROID_EXAMPLES=NO \
    -D INSTALL_PYTHON_EXAMPLES=NO \
    -D BUILD_DOCS=NO \
    -D BUILD_opencv_python2=ON \
    -D BUILD_opencv_python3=NO \
    .. && \
    make VERBOSE=1 && \
    make -j${CPUCOUNT} && \
    make install && \
    rm -rf /opt/opencv-${OPENCV_VERSION} && \
    ln -s /usr/local/lib/python2.7/site-packages/cv2.cpython-36m-x86_64-linux-gnu.so /usr/local/lib/python2.7/site-packages/cv2.so
