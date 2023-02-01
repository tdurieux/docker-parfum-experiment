FROM python:3.7-alpine

ENV PYTHONNUNBUFFERED 1
COPY ./requirements.txt /requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir /app
COPY ./app /app
WORKDIR /app

CMD ["python", "./main.py"]