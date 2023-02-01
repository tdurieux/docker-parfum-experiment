FROM python:3.8
COPY requirements.txt /opt/
RUN pip3 install --no-cache-dir -r /opt/requirements.txt

WORKDIR /opt
