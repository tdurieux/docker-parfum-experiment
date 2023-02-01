FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y python-pip && \
    apt-get install --no-install-recommends -y python3 python3-pip wget libidn11 && \
    apt-get autoclean && apt-get autoremove && rm -rf /var/lib/apt/lists/*
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN wget https://github.com/lh3/minimap2/releases/download/v2.17/minimap2-2.17_x64-linux.tar.bz2 && tar --no-same-owner -jxvf minimap2-2.17_x64-linux.tar.bz2 && rm minimap2-2.17_x64-linux.tar.bz2
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir setuptools==3.0 && apt-get install --no-install-recommends python3-pip -y && git clone https://github.com/dfguan/runner.git && cd /runner && python3 setup.py install && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/dfguan/purge_dups.git && cd /purge_dups/src && make
