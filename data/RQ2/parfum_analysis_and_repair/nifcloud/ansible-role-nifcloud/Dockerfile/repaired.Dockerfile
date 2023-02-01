FROM python:2.7
RUN pip install --no-cache-dir ansible coverage nose mock requests
WORKDIR /work
