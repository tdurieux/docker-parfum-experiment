FROM public.ecr.aws/lambda/python:latest

# install boto3, which is available on Lambda
RUN pip3 install --no-cache-dir boto3

ENTRYPOINT [ "/bin/bash" ]