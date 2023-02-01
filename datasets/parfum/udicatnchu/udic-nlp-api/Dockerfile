# This dockerfile uses the ubuntu image
# VERSION 2 - EDITION 1
# Author: davidtnfsh
# Command format: Instruction [arguments / command] ..

FROM davidtnfsh/python

MAINTAINER davidtnfsh davidtnfsh@gmail.com

ENV LANG=C.UTF-8

RUN mkdir /code
WORKDIR /code
ADD . /code/

# to install numpy, scipy
RUN apt-get update
RUN apt-get -y install libblas-dev liblapack-dev libatlas-base-dev gfortran 

RUN apt-get -y install sudo wget vim

# to install npm
RUN apt-get -y install curl python-software-properties
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y install nodejs

# for kcem
RUN pip3 install git+git://github.com/attardi/wikiextractor.git@2a5e6aebc030c936c7afd0c349e6826c4d02b871

# for MySQL, python3 need to config in specific way...
RUN  apt-get install -y libmysqld-dev

# Language package
# zh
RUN apt-get install -y opencc
# th
RUN apt-get install -y libicu-dev
# jp
RUN apt-get install -y libmecab-dev mecab mecab-ipadic-utf8

# need to be last
RUN pip3 install -r requirements.txt