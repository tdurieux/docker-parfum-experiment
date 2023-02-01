FROM kaixhin/theano:latest
# You need to build with:
# $ docker build -t {tag} -f dockerfiles/base/Dockerfile .
# (in order to copy requirements.txt)

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y libffi-dev libssl-dev libhdf5-dev language-pack-en-base python-pandas python-opencv python-numpy python-h5py && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt
