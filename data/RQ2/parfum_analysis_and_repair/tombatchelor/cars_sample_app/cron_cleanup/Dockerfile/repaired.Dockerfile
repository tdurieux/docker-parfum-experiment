FROM python:3.9

ADD clean_up.py /

RUN pip install --no-cache-dir mysql-connector-python
RUN pip install --no-cache-dir boto3
RUN pip install --no-cache-dir botocore

CMD [ "python", "./clean_up.py" ]

