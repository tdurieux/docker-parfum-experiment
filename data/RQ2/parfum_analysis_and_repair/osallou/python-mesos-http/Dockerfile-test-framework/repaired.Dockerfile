FROM python:2

COPY requirements.txt /tmp
RUN pip install --no-cache-dir -r /tmp/requirements.txt --no-cache

COPY . /tmp

RUN cp /tmp/sample/test.py /test.py \
	&& cd /tmp \
	&& python setup.py install

ENV MESOS_URLS zk://leader.mesos:2181/mesos

CMD ["python", "/test.py"]
