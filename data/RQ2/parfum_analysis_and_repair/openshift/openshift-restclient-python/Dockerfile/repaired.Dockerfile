FROM python:2.7

RUN mkdir /src
WORKDIR /src

COPY requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /src
RUN pip install --no-cache-dir .
