FROM python:3.7-slim

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir boto3~=1.9.197
RUN pip install --no-cache-dir numpy==1.16.2
RUN pip install --no-cache-dir Pillow==5.2.0
RUN pip install --no-cache-dir wo~=0.1.5

COPY *.py /src/
WORKDIR /src/

ENTRYPOINT [ "python", "download.py" ]
