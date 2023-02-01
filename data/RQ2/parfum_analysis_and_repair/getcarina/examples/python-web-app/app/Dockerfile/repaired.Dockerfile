FROM python:3.4

ENV PYTHONUNBUFFERED 1

ADD . /src

WORKDIR /src

RUN pip install --no-cache-dir -r requirements.txt

CMD gunicorn app:app -b 0.0.0.0:8000
