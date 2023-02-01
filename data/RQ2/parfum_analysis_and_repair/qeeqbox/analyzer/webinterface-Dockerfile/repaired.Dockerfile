FROM ubuntu:latest
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y curl python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir requests flask werkzeug gunicorn flask_mongoengine flask_admin flask_login flask_bcrypt pyOpenSSL Flask-Markdown psutil gevent python-dateutil redis pymongo==3.12.1
WORKDIR /analyzer
ADD ./ .
RUN python3 initializer.py --key
WORKDIR /
