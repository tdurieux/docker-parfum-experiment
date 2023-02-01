FROM civisanalytics/datascience-python

WORKDIR /workdir/

COPY requirements.txt /workdir/requirements.txt

RUN pip install --no-cache-dir -r requirements.txt

COPY *.py /workdir/

