FROM dojot/dredd-python:3.6

RUN mkdir -p /usr/src/app/requirements && mkdir -p /usr/src/app/tests
WORKDIR /usr/src/app

ADD requirements/requirements.txt requirements/
ADD tests/requirements.txt tests/
RUN pip install -r /usr/src/app/requirements/requirements.txt
RUN pip install -r /usr/src/app/tests/requirements.txt

ADD . .
ENV PYTHONPATH=${PYTHONPATH}:/usr/src/app
ENV SINGLE_TENANT=true

CMD ["./tests/start-test.sh"]
