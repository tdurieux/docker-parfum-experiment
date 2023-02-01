#FROM python:3.5-alpine
FROM python:3.5-jessie
ADD ./ /sb/
WORKDIR /sb/

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir .

WORKDIR /sb/app/

CMD ["python3", "./app.py"]