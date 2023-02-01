FROM python:3.8.2

RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends -y build-essential libblas-dev liblapack-dev gfortran && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir numpy==1.18.2
RUN pip install --no-cache-dir scipy==1.4.1
RUN pip install --no-cache-dir numba==0.48.0
RUN pip install --no-cache-dir networkx==2.4
RUN pip install --no-cache-dir scikit-learn==0.22.2.post1

CMD ["python"]
