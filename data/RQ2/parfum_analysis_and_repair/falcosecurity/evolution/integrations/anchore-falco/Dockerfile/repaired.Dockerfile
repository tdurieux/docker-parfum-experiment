FROM python:3-stretch

RUN pip install --no-cache-dir pipenv

WORKDIR /app

ADD Pipfile /app/Pipfile
ADD Pipfile.lock /app/Pipfile.lock
RUN pipenv install --system --deploy

ADD . /app

CMD ["python", "main.py"]
