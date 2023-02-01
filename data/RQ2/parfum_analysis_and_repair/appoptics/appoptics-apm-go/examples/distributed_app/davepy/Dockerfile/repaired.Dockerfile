FROM ubuntu:16.04

# Install uWSGI and instrumentation
RUN apt-get update && apt-get -y --no-install-recommends install python-pip python-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir appoptics
RUN pip install --no-cache-dir uwsgi flask

# Script to run before testing to start services such as tracelyzer and apache
ADD start_services.sh /start_services.sh

# uWSGI stack
ADD app /home/app/

EXPOSE 8083
CMD [ "bash", "/start_services.sh" ]

