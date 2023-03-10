FROM quay.io/pypa/manylinux2010_x86_64:2020-04-04-f427f46

ARG PYTHON_VERSION=3.5

ADD scripts /tmp/scripts
RUN /tmp/scripts/install_manylinux2010.sh -p $PYTHON_VERSION && \
   (source /opt/onnxruntime-python/bin/activate; /tmp/scripts/install_deps.sh -p $PYTHON_VERSION) && \
   rm -rf /tmp/scripts  # not useful at all except not to see the scripts

RUN echo "#!/bin/bash" > /opt/entrypoint.sh && \
    echo "set -e" >> /opt/entrypoint.sh && \
    echo "source /opt/onnxruntime-python/bin/activate" >> /opt/entrypoint.sh && \
    echo "exec \"\$@\"" >> /opt/entrypoint.sh
RUN cat /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

WORKDIR /root

ENV LD_LIBRARY_PATH /usr/local/openblas/lib:$LD_LIBRARY_PATH

ARG BUILD_UID=1000
ARG BUILD_USER=onnxruntimedev
WORKDIR /home/$BUILD_USER
# --disabled-password
RUN adduser --comment 'onnxruntime Build User' $BUILD_USER --uid $BUILD_UID
USER $BUILD_USER

ENTRYPOINT ["/opt/entrypoint.sh"]