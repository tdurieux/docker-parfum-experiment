#---------------------------------------------------------------
FROM nvidia/cuda:10.0-cudnn7-runtime-ubuntu18.04 as poldeepner-base
#---------------------------------------------------------------

LABEL maintainer="Michał Marcińczuk <marcinczuk@gmail.com>"

RUN apt-get clean && apt-get update

# Set the locale
RUN apt-get install -y --no-install-recommends locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# update pip
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential python3.6 python3.6-dev python3-pip python3.6-venv && rm -rf /var/lib/apt/lists/*;
RUN python3.6 -m pip install pip --upgrade
RUN python3.6 -m pip install wheel


#---------------------------------------------------------------
FROM poldeepner-base
#---------------------------------------------------------------

RUN pip install --no-cache-dir seqeval
RUN pip install --no-cache-dir keras
RUN pip install --no-cache-dir tensorflow
RUN pip install --no-cache-dir git+https://www.github.com/keras-team/keras-contrib.git
RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir pyfasttext
RUN pip install --no-cache-dir fasttext
RUN pip install --no-cache-dir sklearn
RUN pip install --no-cache-dir scikit-learn==0.22.2.post1
RUN pip install --no-cache-dir python-dateutil
RUN pip install --no-cache-dir nltk
RUN pip install --no-cache-dir gensim
RUN pip install --no-cache-dir allennlp==0.9.0

WORKDIR "/poldeepner"
