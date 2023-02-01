FROM datmo/theano:gpu
MAINTAINER Datmo devs <dev@datmo.io>

# h5py is optional dependency for keras
RUN apt-get update && apt-get install --no-install-recommends -y libhdf5-dev libhdf5-serial-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir keras h5py

WORKDIR /workspace
RUN chmod -R a+w /workspace
