FROM python:2.7

RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends -y build-essential libblas-dev liblapack-dev gfortran && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir numpy==1.8.2
RUN pip install --no-cache-dir scipy==0.13.3

CMD ["python"]
