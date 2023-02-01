FROM tensorflow/tensorflow:2.5.1-gpu
# remove tensorflow docker logo to avoid confusion
RUN apt-get update && apt-get install --no-install-recommends -y gcc-7 g++-7 cmake mpich vim wget curl && rm -rf /var/lib/apt/lists/*;
RUN HOROVOD_WITHOUT_MPI=1 pip3 --no-cache-dir install mpi4py horovod
RUN pip3 install --no-cache-dir pandas scikit-learn deepctr
ADD . /openembedding
RUN pip3 install --no-cache-dir /openembedding/output/dist/openembedding-*.tar.gz
WORKDIR /openembedding
