FROM ubuntu:20.04

WORKDIR /auto-sklearn

# install linux packages
RUN apt-get update

# Set the locale
# workaround for https://github.com/automl/auto-sklearn/issues/867
RUN apt-get -y --no-install-recommends install locales && rm -rf /var/lib/apt/lists/*;
RUN touch /usr/share/locale/locale.alias
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# set environment variables to only use one core
RUN export OPENBLAS_NUM_THREADS=1
RUN export MKL_NUM_THREADS=1
RUN export BLAS_NUM_THREADS=1
RUN export OMP_NUM_THREADS=1

# install build requirements
RUN apt install --no-install-recommends -y python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y swig && rm -rf /var/lib/apt/lists/*;

# Copy the checkout autosklearn version for installation
ADD . /auto-sklearn/

# Upgrade pip then install dependencies
RUN pip3 install --no-cache-dir --upgrade pip

# Install
RUN pip3 install --no-cache-dir "/auto-sklearn[test, examples]"
