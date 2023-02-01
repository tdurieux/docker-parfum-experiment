FROM python:3.7-alpine

RUN mkdir /app
WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000

COPY . /app

ENTRYPOINT ["/bin/sh"]
