FROM quay.io/deis/base:0.3.1

RUN apt-get update && apt-get install --no-install-recommends -y python python-pip python-dev \
    build-essential libffi-dev libpq-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /codesy
ADD requirements.txt /codesy/
RUN pip install --no-cache-dir -r requirements.txt
ADD . /codesy/
CMD newrelic-admin run-program gunicorn -b 0.0.0.0:8000 codesy.wsgi
EXPOSE 8000
