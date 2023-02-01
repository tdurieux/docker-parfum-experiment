FROM python:3.7

RUN pip install --no-cache-dir httplib2
RUN pip install --no-cache-dir couchbase==3.2.7 dnspython
COPY collectionsUtil.py collectionsUtil.py
ENTRYPOINT ["python","collectionsUtil.py"]