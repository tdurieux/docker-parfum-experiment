FROM python:3.8-slim-buster

RUN pip3 install --no-cache-dir requests
RUN pip3 install --no-cache-dir kafka-python

ADD fhirtrigger.py /

CMD [ "python3", "./fhirtrigger.py" ]
