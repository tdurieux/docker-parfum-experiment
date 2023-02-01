FROM python:2.7

RUN mkdir -p /app
COPY . /app/tuxedo/tuxedo
COPY version.json /app/version.json

WORKDIR /app/tuxedo/tuxedo

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y -qq python-mysqldb && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir gunicorn==19.6.0 && \
    cp wsgi/tuxedo.wsgi wsgirunner.py && rm -rf /var/lib/apt/lists/*;

EXPOSE 8000

ENV PYTHONPATH="/app/tuxedo:/app/tuxedo/tuxedo/vendor/lib/python:/app/tuxedo/tuxedo/vendor/src"

CMD ["/app/tuxedo/tuxedo/bin/start", "-b", "127.0.0.1:8000", "-w", "24", "wsgirunner"]
