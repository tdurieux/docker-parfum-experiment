FROM python:3

RUN pip install --no-cache-dir flask

WORKDIR /tmp/app

COPY . /tmp/app

CMD ["python", "app.py"]
