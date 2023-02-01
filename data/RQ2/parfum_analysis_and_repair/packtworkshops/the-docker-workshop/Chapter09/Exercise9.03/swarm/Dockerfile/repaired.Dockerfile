FROM python:3

ENV PYTHONUNBUFFERED 1
RUN mkdir /application
WORKDIR /application
COPY requirements.txt /application/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /application/
