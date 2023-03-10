ARG BASE_IMAGE=""
FROM $BASE_IMAGE

LABEL maintainer="Amazon AI"
LABEL dlc_major_version="1"

ENV SAGEMAKER_TRAINING_MODULE sagemaker_tensorflow_container.training:main

ARG PYTHON=python3.8
# Add arguments to achieve the version, python and url
ARG PYTHON_VERSION=3.8.2

# Starting sagemaker v2.92.0, the requirement of importlib-metadata was restricted from >=1.4.0 to >=1.4.0,<2.0
# However, the markdown package (dependency of tensorboard package) requires importlib-metadata to be >=4.4.
# Issue: https://github.com/aws/sagemaker-python-sdk/pull/3138
RUN $PYTHON -m pip install --no-cache-dir -U \
    "sagemaker>=2,<2.92.0" \
    sagemaker-experiments==0.* \
    "sagemaker-tensorflow>=2.7,<2.8" \
    "sagemaker-tensorflow-training>=20" \
    "sparkmagic<1" \
    "sagemaker-studio-sparkmagic-lib<1" \
    "sagemaker-studio-analytics-extension==0.0.2" \
    smclarify

RUN $PYTHON -m pip install --no-cache-dir -U \
    "bokeh>=2.3,<3" \
    "imageio>=2.9,<3" \
    "opencv-python>=4.6,<5" \
    "plotly>=5.1,<6" \
    "seaborn>=0.11,<1" \
    "numba<0.54" \
    "shap>=0.39,<1"

# install smdebug directly the specific branch
ARG SMDEBUG_VERSION=1.0.12
RUN git clone -b $SMDEBUG_VERSION https://github.com/awslabs/sagemaker-debugger.git \
    && cd sagemaker-debugger && $PYTHON setup.py install && cd .. && rm -rf sagemaker-debugger

# install boost
# tensorflow is compiled with --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0"
RUN wget https://sourceforge.net/projects/boost/files/boost/1.73.0/boost_1_73_0.tar.gz/download -O boost_1_73_0.tar.gz \
   && tar -xzf boost_1_73_0.tar.gz \
   && cd boost_1_73_0 \
   && ./bootstrap.sh \
   && ./b2 define=_GLIBCXX_USE_CXX11_ABI=0 threading=multi --prefix=/usr -j 64 cxxflags=-fPIC cflags=-fPIC install || true \
   && cd .. \
   && rm -rf boost_1_73_0.tar.gz \
   && rm -rf boost_1_73_0 \
   && cd /usr/include/boost

# smdataparallel
ARG SMDATAPARALLEL_BINARY=https://smdataparallel.s3.amazonaws.com/binary/tensorflow/2.7.1/cu112/2022-02-11/smdistributed_dataparallel-1.3.0-cp38-cp38-linux_x86_64.whl

# Install SMD DP binary
RUN SMDATAPARALLEL_TF=1 ${PYTHON} -m pip install --no-cache-dir ${SMDATAPARALLEL_BINARY}

# remove tmp files
RUN rm -rf /tmp/git-secrets

# Add NGC vars
ENV TF_AUTOTUNE_THRESHOLD=2

ENV LD_LIBRARY_PATH="/usr/local/lib/python3.8/site-packages/smdistributed/dataparallel/lib:$LD_LIBRARY_PATH"

ADD https://raw.githubusercontent.com/aws/deep-learning-containers/master/src/deep_learning_container.py /usr/local/bin/deep_learning_container.py

RUN chmod +x /usr/local/bin/deep_learning_container.py

RUN HOME_DIR=/root \
   && curl -f -o ${HOME_DIR}/oss_compliance.zip https://aws-dlinfra-utilities.s3.amazonaws.com/oss_compliance.zip \
   && unzip ${HOME_DIR}/oss_compliance.zip -d ${HOME_DIR}/ \
   && cp ${HOME_DIR}/oss_compliance/test/testOSSCompliance /usr/local/bin/testOSSCompliance \
   && chmod +x /usr/local/bin/testOSSCompliance \
   && chmod +x ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh \
   && ${HOME_DIR}/oss_compliance/generate_oss_compliance.sh ${HOME_DIR} ${PYTHON} \
   && rm -rf ${HOME_DIR}/oss_compliance*

RUN curl -f https://aws-dlc-licenses.s3.amazonaws.com/tensorflow-2.7/license.txt -o /license.txt

CMD ["/bin/bash"]
