FROM python:2.7
RUN apt-get update && apt-get -y --no-install-recommends install python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir aerospike>=1.0.56 tornado
ADD . /code
WORKDIR /code
EXPOSE 8888
ENTRYPOINT ["python","/code/geoproxy"]