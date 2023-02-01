FROM ubuntu:16.04
RUN apt-get update && apt-get install --no-install-recommends -y python python-pip && rm -rf /var/lib/apt/lists/*; # pyhon

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir kubernetes

COPY main.py /main.py

WORKDIR /
CMD python /main.py

