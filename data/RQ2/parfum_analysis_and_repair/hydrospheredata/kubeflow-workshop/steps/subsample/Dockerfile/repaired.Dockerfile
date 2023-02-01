FROM python:3.7-slim

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir boto3~=1.9.197
RUN pip install --no-cache-dir numpy~=1.17.0
RUN pip install --no-cache-dir psycopg2-binary~=2.7.5
RUN pip install --no-cache-dir requests~=2.22.0
RUN pip install --no-cache-dir hydro-serving-grpc~=2.1.0rc1
RUN pip install --no-cache-dir tqdm~=4.23.4
RUN pip install --no-cache-dir wo~=0.1.3.post4

COPY *.py /src/
WORKDIR /src/

ENTRYPOINT [ "python", "subsample.py" ]
