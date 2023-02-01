FROM ubuntu:20.04
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /opt/
RUN pip3 install --no-cache-dir -r /opt/requirements.txt

WORKDIR /opt
CMD FLASK_APP=app FLASK_DEBUG=1 flask run --host 0.0.0.0 --port 5000
