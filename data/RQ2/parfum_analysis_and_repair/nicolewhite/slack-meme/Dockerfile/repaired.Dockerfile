FROM python:3

COPY . /app
WORKDIR /app

RUN pip install --no-cache-dir pipenv
RUN pipenv install --system --deploy

CMD ["gunicorn", "-b 0.0.0.0:5000", "wsgi"]
