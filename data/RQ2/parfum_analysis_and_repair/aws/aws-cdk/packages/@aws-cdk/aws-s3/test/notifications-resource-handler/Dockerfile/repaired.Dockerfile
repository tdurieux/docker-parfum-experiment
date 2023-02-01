FROM public.ecr.aws/lambda/python:3.7

ADD . /opt/lambda
WORKDIR /opt/lambda

RUN pip3 install --no-cache-dir boto3==1.17.42
RUN python3 test_index.py

ENTRYPOINT [ "/bin/bash" ]