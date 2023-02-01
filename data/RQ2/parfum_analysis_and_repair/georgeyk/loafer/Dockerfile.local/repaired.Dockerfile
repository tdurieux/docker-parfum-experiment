FROM python:3.7-slim-buster

WORKDIR /loafer
COPY . /loafer

RUN pip install --no-cache-dir awscli==1.18.32
RUN pip install --no-cache-dir -e .

ENTRYPOINT ["examples/entrypoint.sh"]
