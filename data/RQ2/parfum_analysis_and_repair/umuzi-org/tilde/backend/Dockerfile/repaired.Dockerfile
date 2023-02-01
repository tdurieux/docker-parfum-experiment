FROM python:3.9

# based on https://docs.docker.com/compose/django/https://docs.docker.com/compose/django/+
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir gunicorn

ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /code/
EXPOSE 8000

CMD gunicorn -b :8080 --log-level debug backend.wsgi

