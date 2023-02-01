FROM python:3.6
RUN pip3 install --no-cache-dir asyncio-nats-client==0.8.2
RUN pip3 install --no-cache-dir protobuf==3.6.1
RUN wget https://s3-us-west-2.amazonaws.com/ntnxsherlock-runtimes/python-env.tgz
RUN tar -xvzf python-env.tgz && rm python-env.tgz
RUN mv ./python-env/datastream_pb2.py ./
ADD main.py ./
CMD ["python3", "main.py"]