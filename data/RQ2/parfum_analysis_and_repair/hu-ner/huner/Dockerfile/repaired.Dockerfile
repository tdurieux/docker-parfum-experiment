FROM ubuntu:18.04


# Install build-essential, git, wget, python-dev, pip, BLAS + LAPACK and other dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
build-essential \
gfortran \
git \
wget \
liblapack-dev \
libopenblas-dev \
python-dev \
python-pip \
python-nose \
python-numpy \
python-scipy \
python3-dev \
python3-pip \
python3-nose \
python3-numpy \
python3-scipy \
default-jre \
default-jdk \
curl && rm -rf /var/lib/apt/lists/*;

# Set locale to get file encodings right
RUN apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV workdir /usr/src/myapp
RUN mkdir -p $workdir
WORKDIR $workdir

RUN curl -f -o $workdir/apache-opennlp-1.8.4-bin.tar.xz https://archive.apache.org/dist/opennlp/opennlp-1.8.4/apache-opennlp-1.8.4-bin.tar.gz
RUN tar xzf apache-opennlp-1.8.4-bin.tar.xz && rm apache-opennlp-1.8.4-bin.tar.xz
RUN rm apache-opennlp-1.8.4-bin.tar.xz
RUN mv apache-opennlp-1.8.4/ /usr/bin/

ENV OPENNLP /usr/bin/apache-opennlp-1.8.4

RUN mkdir -p $OPENNLP/models
RUN curl -f -o $OPENNLP/models/en-sent.bin https://opennlp.sourceforge.net/models-1.5/en-sent.bin
RUN curl -f -o $OPENNLP/models/en-token.bin https://opennlp.sourceforge.net/models-1.5/en-token.bin
RUN curl -f -o $OPENNLP/models/en-pos-maxent.bin https://opennlp.sourceforge.net/models-1.5/en-pos-maxent.bin


# Install bleeding-edge Theano
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade six
RUN pip install --no-cache-dir --upgrade --no-deps git+git://github.com/Theano/Theano.git
RUN pip install --no-cache-dir joblib gunicorn flask pexpect

RUN pip3 install --no-cache-dir pexpect tqdm lxml beautifulsoup4



EXPOSE 5000:5000

