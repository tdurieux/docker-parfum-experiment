FROM python:3.5

ENV PYTHONUNBUFFERED 1

RUN pip install --no-cache-dir django >=1.8

ADD ./example_project /app
ADD ./pure_pagination /packages/pure_pagination

ENV PYTHONPATH /packages/
WORKDIR /app

CMD ["python", "manage.py", "runserver", "0.0.0.0:8080"]