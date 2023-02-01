FROM tensorflow/tensorflow:2.2.0-gpu
RUN apt-get update && apt-get install --no-install-recommends -y gcc-7 g++-7 cmake && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir horovod
ADD . /openembedding
WORKDIR /openembedding/laboratory/inject

RUN bash inject.sh
WORKDIR /root
