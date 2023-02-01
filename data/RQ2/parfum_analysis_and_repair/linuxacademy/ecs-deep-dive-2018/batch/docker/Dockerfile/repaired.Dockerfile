FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y python-pip python-pil && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir awscli boto3

ADD GetAndResizeImages.py /

CMD ["/GetAndResizeImages.py"]
