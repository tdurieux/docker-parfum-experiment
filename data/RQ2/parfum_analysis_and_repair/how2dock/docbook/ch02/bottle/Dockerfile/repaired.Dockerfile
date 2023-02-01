FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean all

RUN pip install --no-cache-dir bottle

ADD hello.py /tmp/

EXPOSE 5000

CMD ["python", "/tmp/hello.py"]
