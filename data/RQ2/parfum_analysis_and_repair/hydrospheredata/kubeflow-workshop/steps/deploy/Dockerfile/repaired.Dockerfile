FROM python:3.7-slim

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir boto3~=1.9.197
RUN pip install --no-cache-dir hydrosdk==2.0.0rc10
RUN pip install --no-cache-dir wo~=0.1.5

COPY *.py /src/
WORKDIR /src/

ENTRYPOINT [ "python", "deploy.py" ]
