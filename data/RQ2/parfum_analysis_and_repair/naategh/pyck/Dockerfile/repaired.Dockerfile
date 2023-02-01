FROM python:3.5

RUN mkdir -p /opt/pyck/
WORKDIR /opt/pyck/
COPY ./* ./
RUN pip install --no-cache-dir -r requirements.txt
