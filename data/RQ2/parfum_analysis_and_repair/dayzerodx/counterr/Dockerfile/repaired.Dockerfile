FROM gcr.io/oblivion/ubuntu18_py37:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install python-minimal python-pip python-tk && rm -rf /var/lib/apt/lists/*;

RUN python2.7 -m pip install pysam pandas matplotlib seaborn numpy

RUN git clone https://github.com/dayzerodx/counterr.git && cd counterr && python2.7 setup.py install



