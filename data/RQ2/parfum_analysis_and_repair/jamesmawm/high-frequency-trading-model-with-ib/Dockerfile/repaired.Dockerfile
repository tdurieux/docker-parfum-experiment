FROM python:3.7-stretch
ENV PYTHONUNBUFFERED 1
RUN mkdir /app
WORKDIR /app
COPY . /app/
RUN pip install --no-cache-dir -r requirements.txt