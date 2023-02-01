FROM python:alpine

RUN pip install --no-cache-dir Django

ADD project /opt/project/

WORKDIR /opt/project/

CMD ["python", "manage.py", "runserver"]
