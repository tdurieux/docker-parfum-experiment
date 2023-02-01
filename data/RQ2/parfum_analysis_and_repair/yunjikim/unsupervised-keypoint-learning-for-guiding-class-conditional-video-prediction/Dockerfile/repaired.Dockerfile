FROM nvidia/cuda:9.0-cudnn7-devel

RUN apt-get update && apt-get install --no-install-recommends python3 python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/python3 /usr/bin/python && ln -s /usr/bin/pip3 /usr/bin/pip

ADD requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r /requirements.txt

WORKDIR /workspace