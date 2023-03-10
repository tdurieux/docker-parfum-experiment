FROM quay.io/pypa/manylinux2014_aarch64

RUN yum -y check-update || true && \
    yum install -y \
        sudo \
        wget \
        openssl-devel \
        libffi-devel \
        java-1.8.0-openjdk-devel \
        bzip2-devel \
        gdbm-devel \
        ncurses-devel \
        nss-devel \
        readline-devel \
        sqlite-devel && \
    yum clean all && rm -rf /var/cache/yum

COPY install/install_bazel.sh /install/
RUN /install/install_bazel.sh

ARG py_major_minor_version='3.10'

ENV TF_PYTHON_VERSION=python${py_major_minor_version}
ENV PYTHON_BIN_PATH=/usr/local/bin/${TF_PYTHON_VERSION}

RUN ln -s ${PYTHON_BIN_PATH} /usr/local/bin/python && \
    ln -s ${PYTHON_BIN_PATH} /usr/local/bin/python3

RUN curl -f -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python /tmp/get-pip.py && \
    rm -f /tmp/get-pip.py

RUN export PYTHON_VERSION=$(python -c 'import platform; print(platform.python_version())') && \
    ln -s /opt/_internal/cpython-$PYTHON_VERSION/bin/pip3 /usr/local/bin/pip${py_major_minor_version} && \
    ln -s /opt/_internal/cpython-$PYTHON_VERSION/bin/pip3 /usr/local/bin/pip3 && \
    ln -s /opt/_internal/cpython-$PYTHON_VERSION/bin/pip /usr/local/bin/pip

RUN pip3 install --no-cache-dir packaging

ARG is_nightly=0
ARG tf_project_name='tf_ci_cpu' # PyPI project name passed by CD GitHub workflow

ENV IS_NIGHTLY=${is_nightly}
ENV TF_PROJECT_NAME=${tf_project_name}
