FROM ubuntu:xenial

RUN apt-get update

RUN apt-get install --no-install-recommends -y g++ openjdk-8-jdk python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install konlpy

RUN apt-get install --no-install-recommends -y curl git && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://raw.githubusercontent.com/konlpy/konlpy/master/scripts/mecab.sh | bash

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/konlpy/konlpy konlpy.git
WORKDIR konlpy.git
RUN git checkout master
RUN python3 -m pip install -r requirements-dev.txt
CMD python3 -m pytest -v .