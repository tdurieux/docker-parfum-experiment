From slt.kit-server

#PyTorch
RUN apt-get install --no-install-recommends python3.7 -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends vim -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip python3.7-dev build-essential libyaml-dev && rm -rf /var/lib/apt/lists/*;
RUN python3.7 -m pip install --upgrade pip
RUN python3.7 --version
RUN pip --version
RUN python3.7 -c 'import struct;print(struct.calcsize("P") * 8)'
#RUN python3.7 -m pip install https://download.pytorch.org/whl/cpu/torch-1.0.1-cp37-cp37m-win_amd64.whl && \
RUN python3.7 -m pip install torch==1.0.1 -f https://download.pytorch.org/whl/cpu/stable && \
    python3.7 -m pip install torchvision && \
    python3.7 -m pip install -U numpy && \
    python3.7 -m pip install nltk && \ 
    python3.7 -m pip install h5py

#NMTGMinor
RUN mkdir -p /opt/lib && \
    cd /opt/lib && \
    git clone --single-branch --branch LTTransformer https://github.com/quanpn90/NMTGMinor
    #git clone https://github.com/quanpn90/NMTGMinor

CMD /opt/SLT.KIT/src/server/RUN.sh
