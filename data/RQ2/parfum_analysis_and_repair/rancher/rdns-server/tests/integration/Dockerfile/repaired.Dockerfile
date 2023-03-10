FROM python:2.7.14-stretch

ADD . /integration

WORKDIR /integration

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["./run.sh"]