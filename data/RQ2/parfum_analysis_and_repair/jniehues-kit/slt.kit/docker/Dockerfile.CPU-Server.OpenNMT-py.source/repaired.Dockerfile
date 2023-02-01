From slt.kit-server

#PyTorch
RUN apt-get install --no-install-recommends -y libyaml-dev && \
    pip install --no-cache-dir numpy pyyaml mkl mkl-include setuptools cmake cffi typing future && cd /opt/ \
    && git clone --recursive https://github.com/pytorch/pytorch && cd pytorch && \
    git checkout v0.3.1 && git submodule update --init && python setup.py install && \
    pip install --no-cache-dir "torchvision<0.3" && \
    pip install --no-cache-dir -U numpy && \
    pip install --no-cache-dir -U nltk && rm -rf /var/lib/apt/lists/*;

#OPENNMT
RUN mkdir -p /opt/lib && \
    cd /opt/lib && \
    git clone https://github.com/quanpn90/OpenNMT-py

CMD /opt/SLT.KIT/src/server/RUN.sh
