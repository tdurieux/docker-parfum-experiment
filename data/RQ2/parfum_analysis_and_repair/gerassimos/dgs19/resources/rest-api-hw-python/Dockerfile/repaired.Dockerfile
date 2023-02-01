FROM python:3.8.3-buster

RUN pip install --no-cache-dir flask

ADD app.py /

CMD [ "python", "/app.py" ]