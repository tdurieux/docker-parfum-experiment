FROM python:3.6

ADD . /app
WORKDIR /app

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python3", "/app/src/entrypoint.py"]
