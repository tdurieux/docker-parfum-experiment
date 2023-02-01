FROM nikolaik/python-nodejs:python3.8-nodejs15

USER root
RUN apt-get update && apt-get install --no-install-recommends -y libxmlsec1-dev pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY requirements.txt ./
COPY bridges bridges
COPY logging.conf ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80
CMD [ "gunicorn", "--bind", "0.0.0.0:80", "--workers", "8", "--access-logfile", "-", "bridges.wsgi:app" ]
