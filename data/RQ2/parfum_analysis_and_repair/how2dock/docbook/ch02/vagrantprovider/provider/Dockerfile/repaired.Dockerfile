FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y python && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean all

RUN pip install --no-cache-dir flask

ADD hello.py /tmp/hello.py

EXPOSE 5000

CMD ["python","/tmp/hello.py"]
