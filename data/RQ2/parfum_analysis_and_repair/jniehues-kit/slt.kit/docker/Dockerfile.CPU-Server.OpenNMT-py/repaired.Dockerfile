From slt.kit-server

#PyTorch
RUN apt-get install --no-install-recommends -y libyaml-dev && \
    pip install --no-cache-dir http://download.pytorch.org/whl/cpu/torch-0.3.1-cp27-cp27mu-linux_x86_64.whl && \
    pip install --no-cache-dir "torchvision<0.3" && \
    pip install --no-cache-dir -U numpy && \
    pip install --no-cache-dir -U nltk && rm -rf /var/lib/apt/lists/*;

#OPENNMT
RUN mkdir -p /opt/lib && \
    cd /opt/lib && \
    git clone https://github.com/quanpn90/OpenNMT-py

CMD /opt/SLT.KIT/src/server/RUN.sh