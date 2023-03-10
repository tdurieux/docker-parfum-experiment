from python:3.8

WORKDIR /app

COPY . .
RUN pip install --no-cache-dir --upgrade pip && python setup.py install && pip install --no-cache-dir -r elg/requirements.txt

WORKDIR /app/elg

EXPOSE 8080
ENTRYPOINT gunicorn --bind 0.0.0.0:8080 -t 300 --workers=4 wsgi:app
