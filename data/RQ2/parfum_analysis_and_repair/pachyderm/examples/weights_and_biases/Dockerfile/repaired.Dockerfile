FROM civisanalytics/datascience-python

WORKDIR /workdir/
COPY requirements.txt /workdir/requirements.txt
COPY mnist.py /workdir/mnist.py

RUN pip install --no-cache-dir -r requirements.txt