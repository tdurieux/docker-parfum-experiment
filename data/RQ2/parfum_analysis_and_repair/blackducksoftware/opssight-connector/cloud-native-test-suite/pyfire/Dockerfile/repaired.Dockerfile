FROM python:3.5

RUN pip install --no-cache-dir requests kubernetes; echo $PATH

COPY . .