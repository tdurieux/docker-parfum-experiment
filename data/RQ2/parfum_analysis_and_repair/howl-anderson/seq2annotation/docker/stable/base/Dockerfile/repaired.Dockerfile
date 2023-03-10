FROM tensorflow/tensorflow:1.15.0-gpu-py3

LABEL version="0.0.1-beta"

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN pip3 install --no-cache-dir seq2annotation

# for fix a stupid bug cased by UCloud which always access /usr/bin/python as python bin
RUN ln -s /usr/bin/python3 /usr/bin/python
