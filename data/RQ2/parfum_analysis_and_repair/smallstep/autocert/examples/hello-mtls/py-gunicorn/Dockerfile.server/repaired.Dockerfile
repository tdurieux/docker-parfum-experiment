FROM python:alpine

RUN mkdir /src

# Gunicorn configuration
ADD gunicorn.conf /src

# Flask app
ADD server.py /src
ADD requirements.txt /src
RUN pip3 install --no-cache-dir -r /src/requirements.txt

# app, certificate watcher and envoy
CMD ["gunicorn", "--config", "/src/gunicorn.conf", "--pythonpath", "/src", "server:app"]
