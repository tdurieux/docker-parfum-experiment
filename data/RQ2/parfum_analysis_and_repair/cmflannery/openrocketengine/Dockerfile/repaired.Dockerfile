FROM python:3.7-stretch
RUN mkdir /code
WORKDIR /code
COPY . /code

RUN pip install --no-cache-dir -r requirements.txt

RUN pytest
