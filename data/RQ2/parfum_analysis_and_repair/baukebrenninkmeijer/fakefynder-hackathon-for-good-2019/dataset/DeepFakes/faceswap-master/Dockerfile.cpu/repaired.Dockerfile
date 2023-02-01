FROM tensorflow/tensorflow:latest-py3

RUN apt-get update -qq -y \
 && apt-get install --no-install-recommends -y libsm6 libxrender1 libxext-dev python3-tk \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /opt/
RUN pip3 install --no-cache-dir cmake
RUN pip3 install --no-cache-dir dlib --install-option=--yes --install-option=USE_AVX_INSTRUCTIONS
RUN pip3 --no-cache-dir install -r /opt/requirements.txt && rm /opt/requirements.txt

WORKDIR "/notebooks"
CMD ["/run_jupyter.sh", "--allow-root"]
