FROM python:2.7

RUN mkdir /code
WORKDIR /code
ADD deps/ /code/deps

RUN pip install --no-cache-dir -r deps/requirements.txt
RUN pip install --no-cache-dir -r deps/develop.txt
RUN pip install --no-cache-dir -r deps/extra.txt
RUN pip install --no-cache-dir -r deps/tests.txt

ADD . /code
