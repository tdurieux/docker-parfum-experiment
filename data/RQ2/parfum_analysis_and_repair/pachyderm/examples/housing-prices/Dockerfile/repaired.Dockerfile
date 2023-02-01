FROM civisanalytics/datascience-python
RUN pip install --no-cache-dir seaborn

WORKDIR /workdir/
COPY *.py /workdir/