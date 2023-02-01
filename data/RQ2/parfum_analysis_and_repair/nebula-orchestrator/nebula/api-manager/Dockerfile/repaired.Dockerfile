# using ubuntu because it's the smallest i can use that works with mongo ssl
FROM ubuntu:14.04

# install flask and rabbitmq required
RUN apt-get update && apt-get -y --no-install-recommends install python python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir flask pika Flask-BasicAuth pymongo[tls] gunicorn futures

# copy the codebase
COPY . /www
RUN chmod +x /www/api-manager.py

# adding the config
ADD config.py /etc/gunicorn/config.py

#set python to be unbuffered
ENV PYTHONUNBUFFERED=1

#exposing the port
EXPOSE 80

# and running it
CMD gunicorn --config=/etc/gunicorn/config.py  api-manager:app