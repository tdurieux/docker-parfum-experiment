FROM nvidia/cuda:10.2-base-ubuntu18.04
RUN apt-get update && apt-get install --no-install-recommends -y python3.7 curl python3-distutils && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/bin/python3.7 /usr/bin/python
RUN curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py
RUN python get-pip.py
RUN mkdir /deepcube
COPY ./requirements.txt /deepcube
WORKDIR /deepcube
RUN pip install --no-cache-dir -r requirements.txt
