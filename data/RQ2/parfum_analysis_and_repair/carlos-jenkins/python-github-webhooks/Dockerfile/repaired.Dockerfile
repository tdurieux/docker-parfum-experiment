FROM python:2.7-alpine
MAINTAINER "Matjaž Finžgar" <matjaz@finzgar.net>

WORKDIR /app

COPY requirements.txt /app
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

EXPOSE 5000
CMD ["python", "webhooks.py"]
