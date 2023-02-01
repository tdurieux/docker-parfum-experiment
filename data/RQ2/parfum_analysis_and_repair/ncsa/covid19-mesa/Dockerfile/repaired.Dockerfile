FROM python:3.6-buster

WORKDIR /opt/covid19-mesa
COPY requirements.txt .

RUN pip install --no-cache-dir parsl==0.9.0; pip install --no-cache-dir --force-reinstall "funcx>=0.0.2a0"
RUN pip install --no-cache-dir -r requirements.txt
COPY ./ .