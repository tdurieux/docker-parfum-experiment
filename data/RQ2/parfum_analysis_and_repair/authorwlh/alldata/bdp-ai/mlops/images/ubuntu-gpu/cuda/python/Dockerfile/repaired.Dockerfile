ARG FROM_IMAGES
FROM ${FROM_IMAGES}

ARG PYTHON_VERSION

# 安装python
RUN add-apt-repository -y ppa:deadsnakes/ppa && apt update && apt install --no-install-recommends -y libsasl2-dev libpq-dev python3-pip python3-distutils && rm -rf /var/lib/apt/lists/*;
RUN set -x; rm -rf /usr/bin/python; apt install -y --fix-missing ${PYTHON_VERSION} && ln -s /usr/bin/${PYTHON_VERSION} /usr/bin/python

RUN bash -c "wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py --ignore-installed" \
    && rm -rf /usr/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip

RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir flask requests kubernetes numpy pandas tornado pysnooper


