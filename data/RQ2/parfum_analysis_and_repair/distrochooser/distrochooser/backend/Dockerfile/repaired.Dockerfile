FROM python:3.6
ENV PYTHONUNBUFFERED 1
RUN apt-get update && apt-get install --no-install-recommends -y gcc libpq-dev python3-psycopg2 && rm -rf /var/lib/apt/lists/*;
RUN mkdir /code
WORKDIR /code
ADD requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /code/
expose 8000
CMD ["gunicorn", "backend.wsgi", "--timeout", "600", "-b", "0.0.0.0"]