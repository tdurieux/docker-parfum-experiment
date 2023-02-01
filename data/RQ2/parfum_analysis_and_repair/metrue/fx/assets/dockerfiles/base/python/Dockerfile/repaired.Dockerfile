FROM python:3

RUN pip install --no-cache-dir flask
ENV FLASK_APP=app.py

