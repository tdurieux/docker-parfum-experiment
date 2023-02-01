FROM python:3.9-alpine3.12

COPY requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir -r /code/requirements.txt
COPY docker_custodian/ /code/docker_custodian/
COPY setup.py /code/
RUN pip install --no-cache-dir --no-deps -e /code

ENTRYPOINT ["dcgc"]
