FROM python:3.8-alpine

ENV PYTHONUNBUFFERED 1

WORKDIR /code

COPY requirements.txt /code/
RUN apk update && apk add gcc libressl-dev musl-dev libffi-dev --no-cache
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN apk del gcc libressl-dev musl-dev libffi-dev

COPY . /code/
RUN mkdir /code/logs/
RUN mkdir -p ~/.autodl

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
