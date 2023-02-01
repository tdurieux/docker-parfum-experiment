FROM python:2.7
ADD . /orchestration
WORKDIR /orchestration

RUN mkdir -p /var/log/opensds
RUN pip install --no-cache-dir -r requirements.txt
RUN python setup.py install

CMD ["python", "orchestration/server.py"]
