FROM lithopscloud/ibmcf-python-v38

RUN apt-get update && apt-get install --no-install-recommends -y \
        wget build-essential cmake pkg-config \
        && rm -rf /var/lib/apt/lists/* \
        && apt-cache search linux-headers-generic

RUN pip install --no-cache-dir opencv-contrib-python-headless opencv-python-headless dlib \
    && wget https://sourceforge.net/projects/protomol/files/ProtoMol/Protomol%203.3/ProtoMol-3.3.0-Linux-64bit.tar.gz \
    && tar -zxvf ProtoMol-3.3.0-Linux-64bit.tar.gz \
    && cp /ProtoMol-3.3.0-Linux-64bit/ProtoMol /tmp/ProtoMol \
    && chmod +x /tmp/ProtoMol && rm ProtoMol-3.3.0-Linux-64bit.tar.gz
