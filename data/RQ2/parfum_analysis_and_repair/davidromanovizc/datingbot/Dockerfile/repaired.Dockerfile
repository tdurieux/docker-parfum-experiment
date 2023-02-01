FROM python:3.8.6

WORKDIR /src
COPY requirements.txt /src
RUN pip install --no-cache-dir -r requirements.txt
COPY . /src
