FROM tensorflow/tensorflow:2.2.0-gpu
RUN apt-get update && apt-get install --no-install-recommends -y gcc-7 g++-7 cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim wget && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir horovod pandas scikit-learn deepctr
RUN pip3 install --no-cache-dir jupyter jupyterlab

ADD openembedding-0.1.0.tar.gz /openembedding/openembedding-0.1.0.tar.gz
RUN pip3 install --no-cache-dir /openembedding/openembedding-0.1.0.tar.gz
ADD laboratory/strangedemo/hook /openembedding/hook
WORKDIR /openembedding/hook
RUN bash install.sh
WORKDIR /root
RUN rm -rf /openembedding