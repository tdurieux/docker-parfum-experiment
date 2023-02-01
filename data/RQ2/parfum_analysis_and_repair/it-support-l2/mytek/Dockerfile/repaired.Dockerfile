FROM python:3.9.7-slim-buster
ENV PYTHONUNBUFFERED 1 
RUN pip install --no-cache-dir --upgrade pip
WORKDIR /project
COPY requirements.txt /project/
RUN pip install --no-cache-dir -r requirements.txt
