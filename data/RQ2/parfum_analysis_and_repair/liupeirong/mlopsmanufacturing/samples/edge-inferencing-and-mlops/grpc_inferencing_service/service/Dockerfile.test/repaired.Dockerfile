FROM amd64/python:3.7-slim-buster

RUN mkdir /service
WORKDIR /service

COPY requirements.txt requirements.txt
RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY protos/ /service/protos/
RUN python -m grpc_tools.protoc -I protos protos/*.proto --grpc_python_out=protos --python_out=protos

COPY main.py /service/main.py
COPY core/ /service/core/
COPY tests/ /service/tests/

CMD python -m pytest \
      --with-integration \
      --junitxml=results/test-integration-results.xml tests
