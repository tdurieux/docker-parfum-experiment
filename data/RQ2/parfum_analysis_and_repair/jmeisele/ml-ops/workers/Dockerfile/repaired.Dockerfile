# FROM python:stretch
FROM python:3.8

COPY . /workers

WORKDIR /workers

RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["python3", "app.py"]