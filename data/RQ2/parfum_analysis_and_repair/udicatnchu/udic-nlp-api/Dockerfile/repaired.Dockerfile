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
RUN apt-get -y --no-install-recommends install libblas-dev liblapack-dev libatlas-base-dev gfortran && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install sudo wget vim && rm -rf /var/lib/apt/lists/*;

# to install npm
RUN apt-get -y --no-install-recommends install curl python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

# for kcem
RUN pip3 install --no-cache-dir git+git://github.com/attardi/wikiextractor.git@2a5e6aebc030c936c7afd0c349e6826c4d02b871

# for MySQL, python3 need to config in specific way...
RUN apt-get install --no-install-recommends -y libmysqld-dev && rm -rf /var/lib/apt/lists/*;

# Language package
# zh
RUN apt-get install --no-install-recommends -y opencc && rm -rf /var/lib/apt/lists/*;
# th
RUN apt-get install --no-install-recommends -y libicu-dev && rm -rf /var/lib/apt/lists/*;
# jp
RUN apt-get install --no-install-recommends -y libmecab-dev mecab mecab-ipadic-utf8 && rm -rf /var/lib/apt/lists/*;

# need to be last
RUN pip3 install --no-cache-dir -r requirements.txt