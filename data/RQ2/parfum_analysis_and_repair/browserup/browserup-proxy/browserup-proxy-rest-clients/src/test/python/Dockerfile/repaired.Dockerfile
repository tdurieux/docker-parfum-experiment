FROM python:2.7-alpine

WORKDIR /

COPY client/ /python-client/

# Build python client, install locally
WORKDIR /python-client/
RUN python setup.py install --user
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r test-requirements.txt

COPY . /python/
WORKDIR /python/

CMD ["python", "test/python_test.py"]