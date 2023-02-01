FROM ubuntu:17.10

RUN apt-get update && apt-get -y --no-install-recommends install build-essential python-dev python-pip && rm -rf /var/lib/apt/lists/*;

# Install Node app
RUN mkdir -p /carolpy
COPY app.py /carolpy
COPY requirements.txt /carolpy
WORKDIR /carolpy
RUN pip install --no-cache-dir -r requirements.txt

# Script to run before testing to start services such as tracelyzer and app
ADD start_services.sh /start_services.sh
EXPOSE 8082
CMD [ "bash", "/start_services.sh" ]
