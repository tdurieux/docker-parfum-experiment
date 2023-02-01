FROM python:3.9

RUN pip install --no-cache-dir black

RUN mkdir /src/
WORKDIR /src/

CMD black sweat && black tests
