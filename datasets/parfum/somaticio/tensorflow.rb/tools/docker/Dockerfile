FROM ubuntu:16.04
MAINTAINER nethsix <nethsix@gmail.com>

# Update apt
RUN apt-get update

# Basic utilities
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN apt-get install -y iputils-ping
RUN apt-get install -y dnsutils
RUN apt-get install -y gawk
RUN apt-get install -y gnupg2

# Required to get tensorflow, ruby-tensorflow, etc.
RUN apt-get install -y git

# Required for bazel
RUN apt-get install -y openjdk-8-jdk
RUN echo "deb http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN curl https://storage.googleapis.com/bazel-apt/doc/apt-key.pub.gpg | apt-key add -

# Install bazel
RUN apt-get update && apt-get install -y bazel
RUN apt-get upgrade -y bazel

# Install tensorflow
RUN /bin/mkdir /repos
RUN cd /repos && git clone --recurse-submodules https://github.com/tensorflow/tensorflow
RUN cd /repos/tensorflow && git checkout r1.3

# We need gcc-4.8 otherwise we get segmentation fault
# Error:
# ./tensorflow/core/framework/tensor.h:574:6: internal compiler error: Segmentation fault
#  void Tensor::FillDimsAndValidateCompatibleShape(
#      ^
# gcc: internal compiler error: Segmentation fault (program cc1plus)
RUN apt-get install -y gcc-4.8 g++-4.8
# Set priority to use gcc-4.8
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50 --slave /usr/bin/g++ g++ /usr/bin/g++-4.8

# Required for tensorflow bazel build 
# NOTE: We cannot use python3 because later the ./configure script will
#       it will use /usr/bin/python3 but some bazel stuff still
#       calls /usr/bin/python, which does not link to anything
# RUN apt-get install -y --fix-missing python3-numpy python3-dev python3-pip python3-wheel
RUN apt-get install -y --fix-missing python-numpy python-dev python-pip python-wheel

# For info about why '--jobs'
# * https://github.com/tensorflow/tensorflow/issues/349
# For why we use '--batch'
# * https://github.com/bazelbuild/bazel/issues/418
RUN cd /repos/tensorflow && yes "" | ./configure
RUN cd /repos/tensorflow && bazel --batch build -c opt --jobs=10 --spawn_strategy=standalone --genrule_strategy=standalone //tensorflow:libtensorflow.so
RUN cp /repos/tensorflow/bazel-bin/tensorflow/libtensorflow.so /usr/lib/

# Required by ruby-tensorflow
RUN apt-get install -y swig

# Ruby stuff
# NOTE: keys.gnupg.net is a redirection thus using DNS to resolve
#       that within Docker failse
RUN gpg --keyserver hkp://$(dig +short keys.gnupg.net | awk 'BEGIN { regex="^[0-9.]+$"; ip="" } { if (match($0, regex) && (ip == "")) { ip = $1 } } END { print ip }') --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.2.4"
# NOTE: Cannot find a good way to coordinate rvm and gem
#       thus the belog gem install will end up installing bundler
#       in systems
# RUN /bin/bash -l -c "rvm gemset use ruby-2.2.4@global && gem install bundler --no-rdoc --no-ri"
# Set ruby/gemset to be 2.2.4@global at '/' instead
RUN cd / && /bin/bash -l -c "rvm --ruby-version use 2.2.4@global"
RUN cd / && /bin/bash -l -c "gem install bundler --no-rdoc --no-ri"

RUN echo 'source /etc/profile.d/rvm.sh' >> ~/.bashrc

RUN /bin/bash -l -c "gem install bundle --no-rdoc --no-ri"
RUN /bin/bash -l -c "rvm gemset create ruby-tensorflow"

# Install ruby-tensorflow
RUN cd /repos && git clone https://github.com/somaticio/tensorflow.rb
RUN cd /repos/tensorflow.rb && /bin/bash -l -c "rvm --ruby-version use 2.2.4@ruby-tensorflow"

RUN cd /repos/tensorflow.rb && /bin/bash -l -c "bundle install"

RUN cd /repos/tensorflow.rb/ext/sciruby/tensorflow_c && /bin/bash -l -c "ruby extconf.rb && make && make install"
RUN cd /repos/tensorflow.rb && /bin/bash -l -c "bundle exec rake install"
