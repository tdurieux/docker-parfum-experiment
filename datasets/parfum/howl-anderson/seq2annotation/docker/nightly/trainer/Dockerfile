FROM tensorflow/tensorflow:1.15.0-gpu-py3

LABEL version="0.0.1-beta"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y git

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# need out-of-bound effect move nightly build packge to workshop dir
COPY dist/seq2annotation-*.whl /tmp/
RUN pip3 install /tmp/seq2annotation-*.whl

# for fix a stupid bug cased by UCloud which always access /usr/bin/python as python bin
RUN ln -s /usr/bin/python3 /usr/bin/python

## Application related part start ##

RUN mkdir /app
RUN mkdir /data
WORKDIR /data

COPY entry.bash /app/entry.bash
COPY keras_entry.bash /app/keras_entry.bash

EXPOSE 5000

CMD ["bash", "/app/entry.bash"]