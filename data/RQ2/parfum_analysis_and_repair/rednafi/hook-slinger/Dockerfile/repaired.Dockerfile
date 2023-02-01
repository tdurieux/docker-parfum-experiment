FROM python:3.10-slim-bullseye
ENV PYTHONUNBUFFERED=1


WORKDIR /code
COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /code/
