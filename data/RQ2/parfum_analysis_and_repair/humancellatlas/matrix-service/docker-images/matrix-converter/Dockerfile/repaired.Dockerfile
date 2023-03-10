FROM ubuntu:18.04

RUN apt-get update -y \
 && apt-get install --no-install-recommends -y python3-pip wget \
 && rm -rf /var/lib/apt/lists/*

ADD code /

RUN pip3 install --no-cache-dir -U pip \
 && pip install --no-cache-dir -r /requirements.txt

ENV AWS_DEFAULT_REGION='us-east-1'

RUN chmod +x /matrix_converter.py

CMD ["python3", "/matrix_converter.py"]
