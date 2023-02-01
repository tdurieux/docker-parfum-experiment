FROM python:2.7-alpine

MAINTAINER jacob.everist@gmail.com

RUN pip install --no-cache-dir werkzeug
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir protobuf


EXPOSE 4000

ADD . /python_app

WORKDIR /python_app

CMD [ "python", "yahoo_ticker.py" ]



